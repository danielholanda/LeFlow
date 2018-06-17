`ifndef ALTERA_LNSIM_FUNCTIONS_DEFINED
`define ALTERA_LNSIM_FUNCTIONS_DEFINED
`timescale 1ps/1ps
package altera_lnsim_functions;
	localparam MEM_INIT_STRING_LENGTH = 512;
	localparam MAX_STRING_LENGTH = 20;
	localparam MAX_NUMBER_OF_CLOCKS = 18;
	localparam MAX_VCO_FREQ = 1600000000;  // 1600 MHz
	localparam MIN_VCO_FREQ =  500000;  //  5 KHz --wrahman, this is really << min PFD, see note
	localparam MAX_VCO_FREQ_KHZ = 1600000;
	localparam MIN_VCO_FREQ_KHZ =  500;
	localparam MAX_TOLERANCE = 100;

    // Note: this is a generic PLL sim model, so we "combine" the VCO and PFD
    // limits into one. That's why the min_vco_freq is so low (it's lower than
    // 5 Mhz because there were issues at that limit, we lowered it to 500
    // Khz)



	function integer gcd;
		input integer freq1_i;
		input integer freq2_i;

		integer tmp;
		integer freq1;
		integer freq2;
		integer limit;
		begin
			freq1 = freq1_i;
			freq2 = freq2_i;
			limit = 1000;
			// the two last checks are added to avoid a case
			// of computation error or bad input
			while (freq2 != 0 && freq2 > 0 && limit > 0)
			begin
				tmp = freq2;
				freq2 = freq1 % freq2;
				freq1 = tmp;
				limit = limit - 1;
			end
			gcd = freq1;
		end
	endfunction


	function real abs (real num);
		abs = (num <0) ? -num : num;
	endfunction


	function integer iabs (integer num);
		iabs = (num <0) ? -num : num;
	endfunction

	function integer rounded_division;
		input integer dividend;
		input integer divisor;
		
		integer quotient;
		begin

			quotient = dividend / divisor;
			if (abs( (quotient * divisor) - dividend) >  
				abs( ( (quotient+1)* divisor) - dividend ) )
				quotient = quotient + 1;

			rounded_division = quotient;
		end
	endfunction


	function integer gcd_with_tolerance;
		input integer freq1_i;
		input integer freq2_i;
		input integer tolerance;

		integer tmp;
		integer freq1;
		integer freq2;
		integer limit;
		begin
			freq1 = freq1_i;
			freq2 = freq2_i;
			limit = 1000;
			// the last check is added to avoid a case
			// of computation error or bad input
			while (freq2 != 0 && freq2 > tolerance && (freq2 + tolerance < freq1 || freq2 >= freq1)  && limit > 0)
			begin
				tmp = freq2;
				freq2 = freq1 % freq2;
				freq1 = tmp;
				limit = limit - 1;
			end
			gcd_with_tolerance = (freq2 + tolerance >= freq1 && freq2 > tolerance) ? freq2 : freq1;
		end
	endfunction



	function [8*3:1] get_time_unit;
		input [8*MAX_STRING_LENGTH:1] time_string;

		integer index;
		real result;
		real integer_value;
		real fractional_value;
		real fractional_precision;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8:1] temp_char;
		reg [8:1] temp_digit;
		reg [8*3:1] time_unit;

		begin
			index = 0;
			fractional_precision = 0.0;
			integer_value = 0.0;
			fractional_value = 0.0;
			time_unit = "";

			temp_str = time_string;

			// Get the integer value and fractional value by switching on the decimal point
			for (index = 1; index <= MAX_STRING_LENGTH; index = index + 1)
				begin
					// 1. Get the most signifcant character
					// 2. Convert the char to decimal
					// 3. Shift the temporary string to get the next character
					temp_char = temp_str[160:153];
					temp_digit = temp_char & 8'b00001111;
					temp_str = temp_str << 8;

					// Found the decimal point
					if (temp_char == ".")
						fractional_precision = 1;
					// Found a digit
					else if ((temp_char >= "0") && (temp_char <= "9"))
						if (fractional_precision > 0)
							begin
								fractional_precision = fractional_precision / 10;
								fractional_value = fractional_value + (fractional_precision * temp_digit);
							end
						else
							integer_value = (integer_value * 10) + temp_digit;
					else if ((temp_char >= "a" && temp_char <= "z") || (temp_char >= "A" && temp_char <= "Z"))
						begin
							// Convert to upper case
							if (temp_char >= "a" && temp_char <= "z")
								temp_char = (temp_char & 8'h5f);
							time_unit = (time_unit << 8) | temp_char;
						end
				end

			get_time_unit = time_unit;
		end
	endfunction




	function integer is_period;
		input [8*MAX_STRING_LENGTH:1] time_string;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8*3:1] time_unit;

		begin

			temp_str = time_string;	        
			time_unit = get_time_unit(temp_str);
			

			if (time_unit == "S")
				is_period = 1;
			else if (time_unit == "FS")
				is_period = 1;
			else if (time_unit == "PS")
				is_period = 1;
			else if (time_unit == "NS")
				is_period = 1;
			else if (time_unit == "US")
				is_period = 1;
			else if (time_unit == "MS")
				is_period = 1;
			else if (time_unit == "HZ")
				is_period = 0;
			else if (time_unit == "Hz")
				is_period = 0;
			else if (time_unit == "KHZ")
				is_period = 0;
			else if (time_unit == "KHz")
				is_period = 0;
			else if (time_unit == "MHZ")
				is_period = 0;
			else if (time_unit == "MHz")
				is_period = 0;
			else if (time_unit == "GHZ")
				is_period = 0;
			else if (time_unit == "GHz")
				is_period = 0;
			else
			begin
				is_period = -1;
				$display("Error: Unit \"%s\" is not supported", time_unit);
			end
		end
	endfunction


	function integer get_frequency_value;
		input [8*MAX_STRING_LENGTH:1] time_string;

		integer index;
		real result;
		real integer_value;
		real fractional_value;
		real fractional_precision;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8:1] temp_char;
		reg [8:1] temp_digit;
		reg [8*3:1] time_unit;

		begin
			result = 0.0;
			index = 0;
			fractional_precision = 0.0;
			integer_value = 0.0;
			fractional_value = 0.0;
			time_unit = "";

			temp_str = time_string;
	        
			// Get the integer value and fractional value by switching on the decimal point
			for (index = 1; index <= MAX_STRING_LENGTH; index = index + 1)
				begin
					// 1. Get the most signifcant character
					// 2. Convert the char to decimal
					// 3. Shift the temporary string to get the next character
					temp_char = temp_str[160:153];
					temp_digit = temp_char & 8'b00001111;
					temp_str = temp_str << 8;

					// Found the decimal point
					if (temp_char == ".")
						fractional_precision = 1;
					// Found a digit
					else if ((temp_char >= "0") && (temp_char <= "9"))
						if (fractional_precision > 0)
							begin
								fractional_precision = fractional_precision / 10;
								fractional_value = fractional_value + (fractional_precision * temp_digit);
							end
						else
							integer_value = (integer_value * 10) + temp_digit;
					else if ((temp_char >= "a" && temp_char <= "z") || (temp_char >= "A" && temp_char <= "Z"))
						begin
							// Convert to upper case
							if (temp_char >= "a" && temp_char <= "z")
								temp_char = (temp_char & 8'h5f);
							time_unit = (time_unit << 8) | temp_char;
						end
				end

			// The result is the integer and fractional values      
			result = integer_value + fractional_value;

			// Convert the frequency unit to the resolution of the timescale to fs
			if (time_unit == "HZ")
				result = result;
			if (time_unit == "KHZ")
				result = result * 10**3;
			else if (time_unit == "MHZ")
				result = result * 10**6;
			else if (time_unit == "GHZ")
				result = result * 10**9;
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

			get_frequency_value = result;
		end
	endfunction


	// to avoid overflow
	function integer get_frequency_value_khz;
		input [8*MAX_STRING_LENGTH:1] time_string;

		integer index;
		real result;
		real integer_value;
		real fractional_value;
		real fractional_precision;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8:1] temp_char;
		reg [8:1] temp_digit;
		reg [8*3:1] time_unit;

		begin
			result = 0.0;
			index = 0;
			fractional_precision = 0.0;
			integer_value = 0.0;
			fractional_value = 0.0;
			time_unit = "";

			temp_str = time_string;
	        
			// Get the integer value and fractional value by switching on the decimal point
			for (index = 1; index <= MAX_STRING_LENGTH; index = index + 1)
				begin
					// 1. Get the most signifcant character
					// 2. Convert the char to decimal
					// 3. Shift the temporary string to get the next character
					temp_char = temp_str[160:153];
					temp_digit = temp_char & 8'b00001111;
					temp_str = temp_str << 8;

					// Found the decimal point
					if (temp_char == ".")
						fractional_precision = 1;
					// Found a digit
					else if ((temp_char >= "0") && (temp_char <= "9"))
						if (fractional_precision > 0)
							begin
								fractional_precision = fractional_precision / 10;
								fractional_value = fractional_value + (fractional_precision * temp_digit);
							end
						else
							integer_value = (integer_value * 10) + temp_digit;
					else if ((temp_char >= "a" && temp_char <= "z") || (temp_char >= "A" && temp_char <= "Z"))
						begin
							// Convert to upper case
							if (temp_char >= "a" && temp_char <= "z")
								temp_char = (temp_char & 8'h5f);
							time_unit = (time_unit << 8) | temp_char;
						end
				end

			// The result is the integer and fractional values      
			result = integer_value + fractional_value;

			// Convert the frequency unit to the resolution of the timescale to fs
			if (time_unit == "HZ")
				result = result/10**3;
			if (time_unit == "KHZ")
				result = result;
			else if (time_unit == "MHZ")
				result = result * 10**3;
			else if (time_unit == "GHZ")
				result = result * 10**6;
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

			get_frequency_value_khz = result;
		end
	endfunction



	function integer get_error;
		input integer reference_clock_frequency_value;
		input integer output_clock_frequency_value;

		integer tolerance, min_tol, max_tol;
		reg done;

		integer common_freq;
		integer counter_N;
		integer counter_M;
		
		integer keep_counter_N;
		integer keep_counter_M;

		begin
			keep_counter_N = 512;
			keep_counter_M = 512;
			tolerance = 0;
			done = 0;
			min_tol = 0;
			max_tol = 100;
			while ( !done )
			begin
				common_freq = gcd_with_tolerance(reference_clock_frequency_value,output_clock_frequency_value,tolerance);
				counter_N = rounded_division(reference_clock_frequency_value, common_freq);
				counter_M = rounded_division(output_clock_frequency_value, common_freq);

				// sanity check
				if ( counter_N > 512 || counter_M > 512 || counter_N < 0 || counter_M < 0 )
				begin
					done = 0;
					min_tol = tolerance;
					tolerance = (min_tol + max_tol) / 2;
					if ( tolerance == min_tol )
						tolerance = tolerance + 1;
					if (min_tol >= max_tol)
						done = 1;						
				end
				else
				begin
					if ( tolerance - min_tol < 2 || max_tol - min_tol < 2 )
					begin
						done = 1;
						keep_counter_N = counter_N;
						keep_counter_M = counter_M;
					end
					else
					begin
						max_tol = tolerance;
						tolerance = (min_tol + max_tol) / 2;
					end
				end
			end
			get_error = iabs(keep_counter_N * output_clock_frequency_value -  keep_counter_M * reference_clock_frequency_value);
		end
	endfunction



	function integer compute_pll_frequency;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency0;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency1;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency2;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency3;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency4;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency5;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency6;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency7;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency8;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency9;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency10;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency11;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency12;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency13;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency14;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency15;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency16;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency17;
		input integer number_of_clocks;
		input [8*MAX_STRING_LENGTH:1] reference_clock_frequency;
		input reg use_khz;


		integer output_clock_frequency_value[MAX_NUMBER_OF_CLOCKS-1:0];
		reg [8*MAX_STRING_LENGTH:1] output_clock_frequency_parameter[MAX_NUMBER_OF_CLOCKS-1:0];
		reg ref_specified_as_period;
		reg out_specified_as_period;
		integer reference_clock_frequency_value;
		integer counter_N;
		integer counter_M;
		integer common_freq;
		integer current_lcm;
		integer mult_ratio, max_ratio;
		reg different_format_error;
		integer counter_C[MAX_NUMBER_OF_CLOCKS-1:0];
		
		integer ii;
		reg error;

		integer tolerance, min_tol, max_tol;
		reg done;

		integer tol, minimum_g_tol, keep_ii;
		integer max_vco_freq, min_vco_freq, freq_value;

		begin
			tolerance = 0;
			done = 0;
			error = 0;
			current_lcm = 0;
			min_tol = 0;
			max_tol = 0;
			
			max_vco_freq = (use_khz) ? MAX_VCO_FREQ_KHZ : MAX_VCO_FREQ;
			min_vco_freq = (use_khz) ? MIN_VCO_FREQ_KHZ : MIN_VCO_FREQ;

			output_clock_frequency_parameter[0] = output_clock_frequency0;
			output_clock_frequency_parameter[1] = output_clock_frequency1;
			output_clock_frequency_parameter[2] = output_clock_frequency2;
			output_clock_frequency_parameter[3] = output_clock_frequency3;
			output_clock_frequency_parameter[4] = output_clock_frequency4;
			output_clock_frequency_parameter[5] = output_clock_frequency5;
			output_clock_frequency_parameter[6] = output_clock_frequency6;
			output_clock_frequency_parameter[7] = output_clock_frequency7;
			output_clock_frequency_parameter[8] = output_clock_frequency8;
			output_clock_frequency_parameter[9] = output_clock_frequency9;
			output_clock_frequency_parameter[10] = output_clock_frequency10;
			output_clock_frequency_parameter[11] = output_clock_frequency11;
			output_clock_frequency_parameter[12] = output_clock_frequency12;
			output_clock_frequency_parameter[13] = output_clock_frequency13;
			output_clock_frequency_parameter[14] = output_clock_frequency14;
			output_clock_frequency_parameter[15] = output_clock_frequency15;
			output_clock_frequency_parameter[16] = output_clock_frequency16;
			output_clock_frequency_parameter[17] = output_clock_frequency17;
	

			// we need to have both frequency and period
			if ( is_period(reference_clock_frequency) )
				ref_specified_as_period = 1;
			else
			begin
				ref_specified_as_period = 0;
				freq_value = get_frequency_value(reference_clock_frequency);
				reference_clock_frequency_value = (use_khz) ? freq_value / 1000 : freq_value;
			end

			different_format_error = 0;
			for (ii = 0; ii < MAX_NUMBER_OF_CLOCKS && ii < number_of_clocks; ii = ii + 1 )
			begin
				if ( is_period(output_clock_frequency_parameter[ii]) )
				begin
					if (out_specified_as_period == 0 && ii > 0)
						different_format_error = 1;
					else
						out_specified_as_period = 1;	
				end
				else
				begin
					if (out_specified_as_period == 1 && ii > 0)
						different_format_error = 1;
					else
						out_specified_as_period = 0;
					freq_value = get_frequency_value(output_clock_frequency_parameter[ii]);
					output_clock_frequency_value[ii] =  (use_khz) ? freq_value / 1000 : freq_value;
				end
			end

			if ( different_format_error )
			begin
				error = 1;
				$display("Output frequencies should be specified either all as frequencies or all as periods");
			end


			if (out_specified_as_period == 0 && ref_specified_as_period == 0 )
			begin
				if ( number_of_clocks == 1 )
				begin
					current_lcm = output_clock_frequency_value[0];
				end
				else
				begin
					// try with 0 tolerance first
					tolerance = 0;
					done = 0;
					min_tol = 0;
					max_tol = MAX_TOLERANCE;
					while ( !done )
					begin
						current_lcm = output_clock_frequency_value[0];
						for ( ii = 1; ii < MAX_NUMBER_OF_CLOCKS && ii < number_of_clocks && error == 0; ii = ii + 1 )
						begin
							common_freq = gcd_with_tolerance(current_lcm,output_clock_frequency_value[ii],ii*tolerance);
							// this can cause overflow - first check and then assign
							// current_lcm = (current_lcm / common_freq) * output_clock_frequency_value[ii];
							mult_ratio = (current_lcm / common_freq);
							max_ratio = (max_vco_freq / output_clock_frequency_value[ii]);
							if (max_ratio < mult_ratio)
								current_lcm = max_vco_freq + 1;
							else
								current_lcm = mult_ratio * output_clock_frequency_value[ii];

							if ( current_lcm  > max_vco_freq || current_lcm < min_vco_freq )
							begin
								$display("Violated VCO range %d - %d.",min_vco_freq, max_vco_freq);
								error = 1;
							end
						end
						// if error = 1, we try again with a looser tolerance
						if ( error )
						begin
							if ( tolerance >= MAX_TOLERANCE )
							begin
								// give up
								done = 1;
								error = 1;
							end
							else
							begin
								done = 0;
								error = 0;
								if ( tolerance == 0 )
								begin
									// start binary search
									min_tol = 0;
									max_tol = MAX_TOLERANCE;
									tolerance = (min_tol + max_tol) / 2;
								end
								else
								begin
									min_tol = tolerance;
									tolerance = (min_tol + max_tol) / 2;
									if ( tolerance == min_tol )
										tolerance = tolerance + 1;
								end
							end
						end
						else
						begin
							if ( tolerance - min_tol < 2 || max_tol - min_tol < 2 )
							begin
								done = 1;
							end
							else
							begin
								max_tol = tolerance;
								tolerance = (min_tol + max_tol) / 2;
							end
						end
					end
					for ( ii = 0; ii < MAX_NUMBER_OF_CLOCKS && ii < number_of_clocks && error == 0; ii = ii + 1 )
					begin
						counter_C[ii] = current_lcm / output_clock_frequency_value[ii];
					end
					if ( error == 0 )
					begin
						// common_freq = gcd(reference_clock_frequency_value,current_lcm);
						// counter_N = reference_clock_frequency_value / common_freq;
						// counter_M = current_lcm / common_freq;
						minimum_g_tol = MAX_TOLERANCE;
						keep_ii = 1;
						for ( ii = 1; ii < 20 &&  current_lcm * ii < max_vco_freq; ii = ii + 1 )
						begin
							// tol = get_tolerance( reference_clock_frequency_value, current_lcm * ii);
							tol = get_error( reference_clock_frequency_value, current_lcm * ii);
							if ( tol < minimum_g_tol )
							begin
								minimum_g_tol = tol;
								keep_ii = ii;
							end
						end
						current_lcm = current_lcm * keep_ii;
					end
				end
			end
			else if (out_specified_as_period == 1)
			begin
				counter_N = 1000;
				counter_M = 1000;
			end
			else
			begin
				$display("Output clock frequency is specified in Hz and reference clock in secs");
				$display("Please specify both either as frequencies or as time periods.");
				error = 1;
			end
			
			compute_pll_frequency = (error == 0) ? current_lcm : -1;
		end

	endfunction


	function integer use_khz_values;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency0;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency1;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency2;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency3;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency4;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency5;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency6;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency7;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency8;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency9;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency10;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency11;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency12;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency13;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency14;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency15;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency16;
		input [8*MAX_STRING_LENGTH:1] output_clock_frequency17;
		input integer number_of_clocks;
		input [8*MAX_STRING_LENGTH:1] reference_clock_frequency;


		integer output_clock_frequency_value[MAX_NUMBER_OF_CLOCKS-1:0];
		reg [8*MAX_STRING_LENGTH:1] output_clock_frequency_parameter[MAX_NUMBER_OF_CLOCKS-1:0];
		reg ref_specified_as_period;
		reg out_specified_as_period;
		integer reference_clock_frequency_value;

		reg different_format_error;

		integer ii;
		reg error;
		
		reg missed_precision;
		integer temp_freq;


		begin			
			error = 0;
			missed_precision = 1'b0;
			
			output_clock_frequency_parameter[0] = output_clock_frequency0;
			output_clock_frequency_parameter[1] = output_clock_frequency1;
			output_clock_frequency_parameter[2] = output_clock_frequency2;
			output_clock_frequency_parameter[3] = output_clock_frequency3;
			output_clock_frequency_parameter[4] = output_clock_frequency4;
			output_clock_frequency_parameter[5] = output_clock_frequency5;
			output_clock_frequency_parameter[6] = output_clock_frequency6;
			output_clock_frequency_parameter[7] = output_clock_frequency7;
			output_clock_frequency_parameter[8] = output_clock_frequency8;
			output_clock_frequency_parameter[9] = output_clock_frequency9;
			output_clock_frequency_parameter[10] = output_clock_frequency10;
			output_clock_frequency_parameter[11] = output_clock_frequency11;
			output_clock_frequency_parameter[12] = output_clock_frequency12;
			output_clock_frequency_parameter[13] = output_clock_frequency13;
			output_clock_frequency_parameter[14] = output_clock_frequency14;
			output_clock_frequency_parameter[15] = output_clock_frequency15;
			output_clock_frequency_parameter[16] = output_clock_frequency16;
			output_clock_frequency_parameter[17] = output_clock_frequency17;
	
			// we need to have both frequency and period
			if ( is_period(reference_clock_frequency) )
				ref_specified_as_period = 1;
			else
			begin
				ref_specified_as_period = 0;
				reference_clock_frequency_value = get_frequency_value(reference_clock_frequency);
			end

			different_format_error = 0;
			for (ii = 0; ii < MAX_NUMBER_OF_CLOCKS && ii < number_of_clocks; ii = ii + 1 )
			begin
				if ( is_period(output_clock_frequency_parameter[ii]) )
				begin
					if (out_specified_as_period == 0 && ii > 0)
						different_format_error = 1;
					else
						out_specified_as_period = 1;	
				end
				else
				begin
					if (out_specified_as_period == 1 && ii > 0)
						different_format_error = 1;
					else
						out_specified_as_period = 0;
					output_clock_frequency_value[ii] = get_frequency_value(output_clock_frequency_parameter[ii]);
				end
			end

			if ( different_format_error )
			begin
				error = 1;
				$display("Output frequencies should be specified either all as frequencies or all as periods");
			end


			if (out_specified_as_period == 0 && ref_specified_as_period == 0 )
			begin
				for (ii = 0; ii < MAX_NUMBER_OF_CLOCKS && ii < number_of_clocks; ii = ii + 1 )
				begin
					temp_freq = output_clock_frequency_value[ii] / 1000;
					if ( output_clock_frequency_value[ii] != temp_freq * 1000)
					begin
						missed_precision = 1'b1;
					end
				end
			end
			
			use_khz_values = (error == 0) ? ( (missed_precision == 1'b1) ? 0 : 1 ) : 1;
		end

	endfunction

	function real get_phase_shift_value;
		input [8*MAX_STRING_LENGTH:1] phase_shift_string;
		input [8*MAX_STRING_LENGTH:1] frequency_string;

		integer index;
		real result;
		real integer_value;
		real fractional_value;
		real fractional_precision;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8:1] temp_char;
		reg [8:1] temp_digit;
		reg [8*3:1] time_unit;

        real frequency_value;
        real phase_shift_value;
        reg is_negative;

		begin
            is_negative = 0;
			frequency_value = 0.0;
			phase_shift_value = 0.0;
			result = 0.0;
			index = 0;
			fractional_precision = 0.0;
			integer_value = 0.0;
			fractional_value = 0.0;
			time_unit = "";

			temp_str = phase_shift_string;
	        
			// Get the integer value and fractional value by switching on the decimal point
			for (index = 1; index <= MAX_STRING_LENGTH; index = index + 1)
				begin
					// 1. Get the most signifcant character
					// 2. Convert the char to decimal
					// 3. Shift the temporary string to get the next character
					temp_char = temp_str[160:153];
					temp_digit = temp_char & 8'b00001111;
					temp_str = temp_str << 8;

					// Found the decimal point
					if (temp_char == ".")
						fractional_precision = 1;
					// Found the negative sign
					else if (temp_char == "-")
						is_negative = 1'b1;
					// Found a digit
					else if ((temp_char >= "0") && (temp_char <= "9"))
						if (fractional_precision > 0)
							begin
								fractional_precision = fractional_precision / 10;
								fractional_value = fractional_value + (fractional_precision * temp_digit);
							end
						else
							integer_value = (integer_value * 10) + temp_digit;
					else if ((temp_char >= "a" && temp_char <= "z") || (temp_char >= "A" && temp_char <= "Z"))
						begin
							// Convert to upper case
							if (temp_char >= "a" && temp_char <= "z")
								temp_char = (temp_char & 8'h5f);
							time_unit = (time_unit << 8) | temp_char;
						end
				end

			// The result is the integer and fractional values      
			result = integer_value + fractional_value;

			// Convert the frequency unit to the resolution of the timescale to fs
			if (time_unit == "")
				result = result;
			else if (time_unit == "FS")
				result = result;
			else if (time_unit == "PS")
				result = result * 10**3;
			else if (time_unit == "NS")
				result = result * 10**6;
			else if (time_unit == "US")
				result = result * 10**9;
			else if (time_unit == "MS")
				result = result * 10**12;
			else if (time_unit == "KHZ")
				result = 10**12 / result;
			else if (time_unit == "MHZ")
				result = 10**9 / result;
			else if (time_unit == "GHZ")
				result = 10**6 / result;
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

            //if phase shift is negative, convert it to positive.
            
            if (is_negative)
            begin
                //this should be in picoseconds
                frequency_value = get_time_value (frequency_string);
                //convert it to femtoseconds
                frequency_value = frequency_value * 10**3;
                //convert phase shift to positive
                result = frequency_value - result;
            end


			`ifdef GENERIC_PLL_TIMESCALE_1_FS
				result = result;

			`elsif GENERIC_PLL_TIMESCALE_10_FS
				result = result / 10**1;

			`elsif GENERIC_PLL_TIMESCALE_100_FS
				result = result / 10**2;

			`elsif GENERIC_PLL_TIMESCALE_1_PS
				result = result / 10**3;

			`elsif GENERIC_PLL_TIMESCALE_10_PS
				result = result / 10**4;

			`elsif GENERIC_PLL_TIMESCALE_100_PS
				result = result / 10**5;

			`elsif GENERIC_PLL_TIMESCALE_1_NS
				result = result / 10**6;

			`elsif GENERIC_PLL_TIMESCALE_10_NS
				result = result / 10**7;

			`elsif GENERIC_PLL_TIMESCALE_100_NS
				result = result / 10**8;

			`elsif GENERIC_PLL_TIMESCALE_1_US
				result = result / 10**9;

			`elsif GENERIC_PLL_TIMESCALE_10_US
				result = result / 10**10;

			`elsif GENERIC_PLL_TIMESCALE_100_US
				result = result / 10**11;

			`elsif GENERIC_PLL_TIMESCALE_1_MS
				result = result / 10**12;

			`elsif GENERIC_PLL_TIMESCALE_10_MS
				result = result / 10**13;

			`elsif GENERIC_PLL_TIMESCALE_100_MS
				result = result / 10**14;

			`elsif GENERIC_PLL_TIMESCALE_1_S
				result = result / 10**15;

			`else
				result = result / 10**3;

			`endif

			get_phase_shift_value = result;
		end
	endfunction


	function real get_real_value;
		input [8*MAX_STRING_LENGTH:1] time_string;

		integer index;
		real result;
		real integer_value;
		real fractional_value;
		real fractional_precision;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8:1] temp_char;
		reg [8:1] temp_digit;
		reg [8*3:1] time_unit;

		begin
			result = 0.0;
			index = 0;
			fractional_precision = 0.0;
			integer_value = 0.0;
			fractional_value = 0.0;
			time_unit = "";

			temp_str = time_string;
	        
			// Get the integer value and fractional value by switching on the decimal point
			for (index = 1; index <= MAX_STRING_LENGTH; index = index + 1)
				begin
					// 1. Get the most signifcant character
					// 2. Convert the char to decimal
					// 3. Shift the temporary string to get the next character
					temp_char = temp_str[160:153];
					temp_digit = temp_char & 8'b00001111;
					temp_str = temp_str << 8;

					// Found the decimal point
					if (temp_char == ".")
						fractional_precision = 1;
					// Found a digit
					else if ((temp_char >= "0") && (temp_char <= "9"))
						if (fractional_precision > 0)
							begin
								fractional_precision = fractional_precision / 10;
								fractional_value = fractional_value + (fractional_precision * temp_digit);
							end
						else
							integer_value = (integer_value * 10) + temp_digit;
					else if ((temp_char >= "a" && temp_char <= "z") || (temp_char >= "A" && temp_char <= "Z"))
						begin
							// Convert to upper case
							if (temp_char >= "a" && temp_char <= "z")
								temp_char = (temp_char & 8'h5f);
							time_unit = (time_unit << 8) | temp_char;
						end
				end

			// The result is the integer and fractional values      
			result = integer_value + fractional_value;

			// Convert the frequency unit to the resolution of the timescale to fs
			if (time_unit == "")
				result = result;
			else if (time_unit == "FS")
				result = result;
			else if (time_unit == "PS")
				result = result * 10**3;
			else if (time_unit == "NS")
				result = result * 10**6;
			else if (time_unit == "US")
				result = result * 10**9;
			else if (time_unit == "MS")
				result = result * 10**12;
			else if (time_unit == "KHZ")
				result = 10**12 / result;
			else if (time_unit == "MHZ")
				result = 10**9 / result;
			else if (time_unit == "GHZ")
				result = 10**6 / result;
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

			`ifdef GENERIC_PLL_TIMESCALE_1_FS
				result = result;

			`elsif GENERIC_PLL_TIMESCALE_10_FS
				result = result / 10**1;

			`elsif GENERIC_PLL_TIMESCALE_100_FS
				result = result / 10**2;

			`elsif GENERIC_PLL_TIMESCALE_1_PS
				result = result / 10**3;

			`elsif GENERIC_PLL_TIMESCALE_10_PS
				result = result / 10**4;

			`elsif GENERIC_PLL_TIMESCALE_100_PS
				result = result / 10**5;

			`elsif GENERIC_PLL_TIMESCALE_1_NS
				result = result / 10**6;

			`elsif GENERIC_PLL_TIMESCALE_10_NS
				result = result / 10**7;

			`elsif GENERIC_PLL_TIMESCALE_100_NS
				result = result / 10**8;

			`elsif GENERIC_PLL_TIMESCALE_1_US
				result = result / 10**9;

			`elsif GENERIC_PLL_TIMESCALE_10_US
				result = result / 10**10;

			`elsif GENERIC_PLL_TIMESCALE_100_US
				result = result / 10**11;

			`elsif GENERIC_PLL_TIMESCALE_1_MS
				result = result / 10**12;

			`elsif GENERIC_PLL_TIMESCALE_10_MS
				result = result / 10**13;

			`elsif GENERIC_PLL_TIMESCALE_100_MS
				result = result / 10**14;

			`elsif GENERIC_PLL_TIMESCALE_1_S
				result = result / 10**15;

			`else
				result = result / 10**3;

			`endif

			get_real_value = result;
		end
	endfunction

	function time get_time_value;
		input [8*MAX_STRING_LENGTH:1] time_string;

		integer index;
		time result;
		real integer_value;
		real fractional_value;
		real fractional_precision;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8:1] temp_char;
		reg [8:1] temp_digit;
		reg [8*3:1] time_unit;

		begin
			result = 0;
			index = 0;
			fractional_precision = 0.0;
			integer_value = 0.0;
			fractional_value = 0.0;
			time_unit = "";

			temp_str = time_string;
	        
			// Get the integer value and fractional value by switching on the decimal point
			for (index = 1; index <= MAX_STRING_LENGTH; index = index + 1)
				begin
					// 1. Get the most signifcant character
					// 2. Convert the char to decimal
					// 3. Shift the temporary string to get the next character
					temp_char = temp_str[160:153];
					temp_digit = temp_char & 8'b00001111;
					temp_str = temp_str << 8;

					// Found the decimal point
					if (temp_char == ".")
						fractional_precision = 1;
					// Found a digit
					else if ((temp_char >= "0") && (temp_char <= "9"))
						if (fractional_precision > 0)
							begin
								fractional_precision = fractional_precision / 10;
								fractional_value = fractional_value + (fractional_precision * temp_digit);
							end
						else
							integer_value = (integer_value * 10) + temp_digit;
					else if ((temp_char >= "a" && temp_char <= "z") || (temp_char >= "A" && temp_char <= "Z"))
						begin
							// Convert to upper case
							if (temp_char >= "a" && temp_char <= "z")
								temp_char = (temp_char & 8'h5f);
							time_unit = (time_unit << 8) | temp_char;
						end
				end

			// The result is the integer and fractional values      
			result = integer_value + fractional_value;

			// Convert the frequency unit to the resolution of the timescale (currently ps)
			if (time_unit == "")
				result = result;
			else if (time_unit == "FS")
				result = result / 10**3;
			else if (time_unit == "PS")
				result = result;
			else if (time_unit == "NS")
				result = result * 10**3;
			else if (time_unit == "US")
				result = result * 10**6;
			else if (time_unit == "MS")
				result = result * 10**9;
			else if (time_unit == "KHZ")
				result = 10**9 / result;
			else if (time_unit == "MHZ")
				result = 10**6 / result;
			else if (time_unit == "GHZ")
				result = 10**3 / result;
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

			get_time_value = result;
		end
	endfunction


	function [8*MAX_STRING_LENGTH-1:0] convert_to_mhz_string;
		input integer freq_value;
		input khz;

		integer n_mhz;
		integer fractional;
		const integer mega = 1000000;
		integer actual_value;
		integer current_value, v1ghz, v100khz, threshold;
		reg [8*MAX_STRING_LENGTH-1:0] mhz_string;
		reg [8*MAX_STRING_LENGTH-1:0] f_mhz_string;
		integer digit, index, ii;
		begin
			for ( ii = 0; ii < MAX_STRING_LENGTH; ii = ii + 1 )
			begin
				mhz_string[ii*8 +: 8] = "";
				f_mhz_string[ii*8 +: 8] = "";
			end
			n_mhz = freq_value / mega;
			fractional = freq_value % mega;
			actual_value = n_mhz * mega + fractional;
			if ( actual_value != freq_value)
			begin
				$display("Error: Unexpected precision error getting %d instead of %d",actual_value, freq_value);
			end
			current_value = freq_value;
			if ( khz == 0 )
			begin
				v1ghz = 1000000000;
				v100khz = 100000;
			end
			else
			begin
				v1ghz = 1000000;
				v100khz = 100;
			end
			threshold = v1ghz;
			while ( threshold > current_value)
			begin
				threshold = threshold / 10;
			end
			index = 0;
			while (index < MAX_STRING_LENGTH && (current_value > 0 || threshold > v100khz) )
			begin
				if ( threshold == v100khz )
				begin
					mhz_string[index*8 +: 8] = ".";
					index = index + 1;
				end
				digit = current_value / threshold;
				mhz_string[index*8 +: 8] = digit + "0";
				index = index + 1;
				current_value = current_value % threshold;
				threshold = threshold / 10;	
			end
			mhz_string[index*8 +: 8] = " ";
			index = index + 1;
			mhz_string[index*8 +: 8] = "M";
			index = index + 1;
			mhz_string[index*8 +: 8] = "H";
			index = index + 1;
			mhz_string[index*8 +: 8] = "Z";
			
			for ( ii = 0; ii < index + 1; ii = ii + 1)
			begin
				f_mhz_string[ii*8 +: 8] = mhz_string[(index-ii)*8 +: 8];
			end

			convert_to_mhz_string = f_mhz_string;
		end
	endfunction




	function [8*MAX_STRING_LENGTH-1:0] get_time_string;
		input time time_value;
		input [8*MAX_STRING_LENGTH:1] time_unit;

		integer pos;
		integer initial_pos;
		integer f_unit;	// 10**f_unit is offset from Hz for larger unit

		begin
			// Convert the frequency unit to the resolution of the timescale (currently ps)
			if (time_unit == "")
				begin
					get_time_string = "0 ps";
					initial_pos = 3;
					f_unit = -1;
				end
			else if (time_unit == "fs")
				begin
					get_time_string = "0.000000 fs";
					initial_pos = 3;
				end
			else if (time_unit == "ps")
				begin
					get_time_string = "0 ps";
					initial_pos = 3;
					f_unit = -1;
				end
			else if (time_unit == "ns")
				begin
					get_time_string = "0.000000 ns";
					initial_pos = 3;
				end
			else if (time_unit == "us")
				begin
					get_time_string = "0.000000 us";
					initial_pos = 3;
				end
			else if (time_unit == "ms")
				begin
					get_time_string = "0.000000 ms";
					initial_pos = 3;
				end
			else if (time_unit == "kHz")
				begin
					get_time_string = "0.000000 kHz";
					initial_pos = 4;
				end
			else if (time_unit == "KHZ")
				begin
					get_time_string = "0.000000 KHZ";
					initial_pos = 4;
				end
			else if (time_unit == "MHz")
				begin
					get_time_string = "0.000000 MHz";
					initial_pos = 4;
				end
			else if (time_unit == "GHz")
				begin
					get_time_string = "0.000000 GHz";
					initial_pos = 4;
				end
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

			// Convert time back to string with frequency units
			// Since char inital positions are used by <time_unit>, start with digits at initial_pos
			for (pos = initial_pos; pos < MAX_STRING_LENGTH && time_value > 0; pos = pos + 1)
				begin
					if (f_unit == 0)
						begin
							get_time_string[pos*8 +: 8] = 8'h2e;
							pos = pos + 1;
						end
					f_unit = f_unit - 1;
					get_time_string[pos*8 +: 8] = (time_value % 10) | 8'h30;
					time_value = time_value / 10;
				end
		end

	endfunction

	//--------------------------------------------------------------------------
	// Function Name    : hexToBits
	// Description      : takes in a hexadecimal character and returns the 4-bit 
	//                    value of the character. Returns 0 if character is not 
	//                    a hexadecimal character    
	//--------------------------------------------------------------------------
	
	function [3 : 0]  hexToBits;
		input [7 : 0] character;
		begin
			case ( character )
				"0" : hexToBits = 4'b0000;
				"1" : hexToBits = 4'b0001;
				"2" : hexToBits = 4'b0010;
				"3" : hexToBits = 4'b0011;
				"4" : hexToBits = 4'b0100;
				"5" : hexToBits = 4'b0101;
				"6" : hexToBits = 4'b0110;                    
				"7" : hexToBits = 4'b0111;
				"8" : hexToBits = 4'b1000;
				"9" : hexToBits = 4'b1001;
				"A" : hexToBits = 4'b1010;
				"a" : hexToBits = 4'b1010;
				"B" : hexToBits = 4'b1011;
				"b" : hexToBits = 4'b1011;
				"C" : hexToBits = 4'b1100;
				"c" : hexToBits = 4'b1100;          
				"D" : hexToBits = 4'b1101;
				"d" : hexToBits = 4'b1101;
				"E" : hexToBits = 4'b1110;
				"e" : hexToBits = 4'b1110;
				"F" : hexToBits = 4'b1111;
				"f" : hexToBits = 4'b1111;          
				default :
					begin 
						hexToBits = 4'b0000;
					end
			endcase        
		end
	endfunction
	
	//--------------------------------------------------------------------------
	// Function Name    : strtobits
	// Description      : takes in a string where each character represents a
	//                    hexadecimal number, transforms that number into 4-bits,
	//                    concatenates the result and returns it.
	//--------------------------------------------------------------------------
	
	function [4*MEM_INIT_STRING_LENGTH -1 : 0]  strtobits;
		input [8*MEM_INIT_STRING_LENGTH : 1] my_string;
		begin
			integer char_idx;
			integer bit_idx;
			reg[7 : 0] my_char;
			reg[3 : 0] hex_value;
			reg[4*MEM_INIT_STRING_LENGTH - 1 : 0] temp_bits;
			
			if(my_string == "")
				begin
					temp_bits = 'b0;
				end
			else
				begin
					bit_idx = 0;
					for (char_idx = 1; char_idx < 8*MEM_INIT_STRING_LENGTH; char_idx = char_idx + 8)
						begin : string_loop
							my_char[0] = my_string[char_idx];
							my_char[1] = my_string[char_idx+1];
							my_char[2] = my_string[char_idx+2];
							my_char[3] = my_string[char_idx+3];
							my_char[4] = my_string[char_idx+4];
							my_char[5] = my_string[char_idx+5];
							my_char[6] = my_string[char_idx+6];
							my_char[7] = my_string[char_idx+7];
							
							hex_value = hexToBits(my_char[7:0]);
							
							temp_bits[bit_idx] = hex_value[0];
							temp_bits[bit_idx+1] = hex_value[1];
							temp_bits[bit_idx+2] = hex_value[2];
							temp_bits[bit_idx+3] = hex_value[3];
							
							bit_idx = bit_idx + 4;
						end // string_loop
				end
			strtobits = temp_bits;
		end
	endfunction
	
endpackage
`endif
// (C) 2001-2010 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

`timescale 1ps/1ps
module altera_pll
#(
    //parameter
    parameter reference_clock_frequency       = "0 ps",
	parameter fractional_vco_multiplier       = "false",
    parameter pll_type                        = "General",
    parameter pll_subtype                     = "General",
    parameter number_of_clocks                   = 1,
    parameter operation_mode                  = "internal feedback",
    parameter deserialization_factor           = 4,
    parameter data_rate                       = 0,
    
    parameter sim_additional_refclk_cycles_to_lock      = 0,
    parameter output_clock_frequency0           = "0 ps",
    parameter phase_shift0                      = "0 ps",
    parameter duty_cycle0                      = 50,
    
    parameter output_clock_frequency1           = "0 ps",
    parameter phase_shift1                      = "0 ps",
    parameter duty_cycle1                      = 50,
    
    parameter output_clock_frequency2           = "0 ps",
    parameter phase_shift2                      = "0 ps",
    parameter duty_cycle2                      = 50,
    
    parameter output_clock_frequency3           = "0 ps",
    parameter phase_shift3                      = "0 ps",
    parameter duty_cycle3                      = 50,
    
    parameter output_clock_frequency4           = "0 ps",
    parameter phase_shift4                      = "0 ps",
    parameter duty_cycle4                      = 50,
    
    parameter output_clock_frequency5           = "0 ps",
    parameter phase_shift5                      = "0 ps",
    parameter duty_cycle5                      = 50,
    
    parameter output_clock_frequency6           = "0 ps",
    parameter phase_shift6                      = "0 ps",
    parameter duty_cycle6                      = 50,
    
    parameter output_clock_frequency7           = "0 ps",
    parameter phase_shift7                      = "0 ps",
    parameter duty_cycle7                      = 50,
    
    parameter output_clock_frequency8           = "0 ps",
    parameter phase_shift8                      = "0 ps",
    parameter duty_cycle8                      = 50,
    
    parameter output_clock_frequency9           = "0 ps",
    parameter phase_shift9                      = "0 ps",
    parameter duty_cycle9                      = 50,    

    
    parameter output_clock_frequency10           = "0 ps",
    parameter phase_shift10                      = "0 ps",
    parameter duty_cycle10                      = 50,
    
    parameter output_clock_frequency11           = "0 ps",
    parameter phase_shift11                      = "0 ps",
    parameter duty_cycle11                      = 50,
    
    parameter output_clock_frequency12           = "0 ps",
    parameter phase_shift12                      = "0 ps",
    parameter duty_cycle12                      = 50,
    
    parameter output_clock_frequency13           = "0 ps",
    parameter phase_shift13                      = "0 ps",
    parameter duty_cycle13                      = 50,
    
    parameter output_clock_frequency14           = "0 ps",
    parameter phase_shift14                      = "0 ps",
    parameter duty_cycle14                      = 50,
    
    parameter output_clock_frequency15           = "0 ps",
    parameter phase_shift15                      = "0 ps",
    parameter duty_cycle15                      = 50,
    
    parameter output_clock_frequency16           = "0 ps",
    parameter phase_shift16                      = "0 ps",
    parameter duty_cycle16                      = 50,
    
    parameter output_clock_frequency17           = "0 ps",
    parameter phase_shift17                      = "0 ps",
    parameter duty_cycle17                      = 50,
    
    parameter m_cnt_hi_div                       = 1,
    parameter m_cnt_lo_div                       = 1,
    parameter m_cnt_bypass_en                   = "false",
    parameter m_cnt_odd_div_duty_en           = "false",
    parameter n_cnt_hi_div                       = 1,
    parameter n_cnt_lo_div                       = 1,
    parameter n_cnt_bypass_en                   = "false",
    parameter n_cnt_odd_div_duty_en           = "false",
    parameter c_cnt_hi_div0                      = 1, 
    parameter c_cnt_lo_div0                      = 1,
    parameter c_cnt_bypass_en0                  = "false",
	parameter c_cnt_in_src0                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en0              = "false",
    parameter c_cnt_prst0                  = 1,
    parameter c_cnt_ph_mux_prst0                  = 0,
    parameter c_cnt_hi_div1                      = 1, 
    parameter c_cnt_lo_div1                      = 1,
    parameter c_cnt_bypass_en1                  = "false",
	parameter c_cnt_in_src1                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en1              = "false",
    parameter c_cnt_prst1                  = 1,
    parameter c_cnt_ph_mux_prst1                  = 0,
    parameter c_cnt_hi_div2                      = 1, 
    parameter c_cnt_lo_div2                                              = 1,
    parameter c_cnt_bypass_en2                  = "false",
	parameter c_cnt_in_src2                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en2 = "false",
    parameter c_cnt_prst2                  = 1,
    parameter c_cnt_ph_mux_prst2                  = 0,
    parameter c_cnt_hi_div3                      = 1, 
    parameter c_cnt_lo_div3                                              = 1,
    parameter c_cnt_bypass_en3                  = "false",
	parameter c_cnt_in_src3                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en3 = "false",
    parameter c_cnt_prst3                  = 1,
    parameter c_cnt_ph_mux_prst3                  = 0,
    parameter c_cnt_hi_div4                      = 1, 
    parameter c_cnt_lo_div4                                              = 1,
    parameter c_cnt_bypass_en4                  = "false",
	parameter c_cnt_in_src4                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en4 = "false",
    parameter c_cnt_prst4                  = 1,
    parameter c_cnt_ph_mux_prst4                  = 0,
    parameter c_cnt_hi_div5                      = 1, 
    parameter c_cnt_lo_div5                                              = 1,
    parameter c_cnt_bypass_en5                  = "false",
	parameter c_cnt_in_src5                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en5 = "false",
    parameter c_cnt_prst5                  = 1,
    parameter c_cnt_ph_mux_prst5                  = 0,
    parameter c_cnt_hi_div6                      = 1, 
    parameter c_cnt_lo_div6                                              = 1,
    parameter c_cnt_bypass_en6                  = "false",
	parameter c_cnt_in_src6                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en6 = "false",
    parameter c_cnt_prst6                  = 1,
    parameter c_cnt_ph_mux_prst6                  = 0,
    parameter c_cnt_hi_div7                      = 1, 
    parameter c_cnt_lo_div7                                              = 1,
    parameter c_cnt_bypass_en7                  = "false",
	parameter c_cnt_in_src7                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en7 = "false",
    parameter c_cnt_prst7                  = 1,
    parameter c_cnt_ph_mux_prst7                  = 0,
    parameter c_cnt_hi_div8                      = 1, 
    parameter c_cnt_lo_div8                                              = 1,
    parameter c_cnt_bypass_en8                  = "false",
	parameter c_cnt_in_src8                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en8 = "false",
    parameter c_cnt_prst8                  = 1,
    parameter c_cnt_ph_mux_prst8                  = 0,
    parameter c_cnt_hi_div9                      = 1, 
    parameter c_cnt_lo_div9                                              = 1,
    parameter c_cnt_bypass_en9                  = "false",
	parameter c_cnt_in_src9                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en9 = "false",
    parameter c_cnt_prst9                  = 1,
    parameter c_cnt_ph_mux_prst9                  = 0,
    parameter c_cnt_hi_div10                      = 1, 
    parameter c_cnt_lo_div10                                              = 1,
    parameter c_cnt_bypass_en10                  = "false",
	parameter c_cnt_in_src10                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en10 = "false",
    parameter c_cnt_prst10                  = 1,
    parameter c_cnt_ph_mux_prst10                  = 0,
    parameter c_cnt_hi_div11                      = 1, 
    parameter c_cnt_lo_div11                                              = 1,
    parameter c_cnt_bypass_en11                  = "false",
	parameter c_cnt_in_src11                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en11 = "false",
    parameter c_cnt_prst11                  = 1,
    parameter c_cnt_ph_mux_prst11                  = 0,
    parameter c_cnt_hi_div12                      = 1, 
    parameter c_cnt_lo_div12                                              = 1,
    parameter c_cnt_bypass_en12                  = "false",
	parameter c_cnt_in_src12                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en12 = "false",
    parameter c_cnt_prst12                  = 1,
    parameter c_cnt_ph_mux_prst12                  = 0,
    parameter c_cnt_hi_div13                      = 1, 
    parameter c_cnt_lo_div13                                              = 1,
    parameter c_cnt_bypass_en13                  = "false",
	parameter c_cnt_in_src13                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en13 = "false",
    parameter c_cnt_prst13                  = 1,
    parameter c_cnt_ph_mux_prst13                  = 0,
    parameter c_cnt_hi_div14                      = 1, 
    parameter c_cnt_lo_div14                                              = 1,
    parameter c_cnt_bypass_en14                  = "false",
	parameter c_cnt_in_src14                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en14 = "false",
    parameter c_cnt_prst14                  = 1,
    parameter c_cnt_ph_mux_prst14                  = 0,
    parameter c_cnt_hi_div15                      = 1, 
    parameter c_cnt_lo_div15                                              = 1,
    parameter c_cnt_bypass_en15                  = "false",
	parameter c_cnt_in_src15                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en15 = "false",
    parameter c_cnt_prst15                  = 1,
    parameter c_cnt_ph_mux_prst15                  = 0,
    parameter c_cnt_hi_div16                      = 1, 
    parameter c_cnt_lo_div16                                              = 1,
    parameter c_cnt_bypass_en16                  = "false",
	parameter c_cnt_in_src16                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en16 = "false",
    parameter c_cnt_prst16                  = 1,
    parameter c_cnt_ph_mux_prst16                  = 0,
    parameter c_cnt_hi_div17                      = 1, 
    parameter c_cnt_lo_div17                                              = 1,
    parameter c_cnt_bypass_en17                  = "false",
	parameter c_cnt_in_src17                     = "ph_mux_clk",
    parameter c_cnt_odd_div_duty_en17 = "false",
    parameter c_cnt_prst17                  = 1,
    parameter c_cnt_ph_mux_prst17                  = 0,
    parameter pll_vco_div = 1,
    parameter pll_output_clk_frequency = "0 MHz",
    parameter pll_cp_current = 0,
    parameter pll_bwctrl = 0,
    parameter pll_fractional_division = 1,
    parameter pll_fractional_cout = 24,
    parameter pll_dsm_out_sel = "1st_order",
    parameter mimic_fbclk_type = "gclk",
    parameter pll_fbclk_mux_1 = "glb",
    parameter pll_fbclk_mux_2 = "fb_1",
    parameter pll_m_cnt_in_src = "ph_mux_clk",

    parameter refclk1_frequency = "0 MHz",
    parameter pll_clkin_0_src = "clk_0",
    parameter pll_clkin_1_src = "clk_0",
    parameter pll_clk_loss_sw_en = "false",
    parameter pll_auto_clk_sw_en = "false",
    parameter pll_manu_clk_sw_en = "false", 
    parameter pll_clk_sw_dly = 0        
   // parameter clock_switchover_mode           = "Auto",
    //parameter clock_switchover_delay           = 3,
) ( 

    //input
    input    refclk,
    input    refclk1,
    input    fbclk,
    input    rst,
    input    phase_en,
    input    updn,
    input    scanclk,
    input    [4:0] cntsel,
    input    [63:0] reconfig_to_pll,
    input    extswitch,
    input    adjpllin,
    input    cclk,
    
    //output
    output    [ number_of_clocks -1 : 0] outclk,
    output    fboutclk,
    output    locked,
    output    phase_done,
    output    [63:0]    reconfig_from_pll,
    output    activeclk,
    output    [1:0] clkbad,
	output    [7:0] phout,
    output    [ number_of_clocks -1 : 0] cascade_out,

    //inout
    inout zdbfbclk
    
);


// synthesis translate off
import altera_lnsim_functions::*;
// synthesis translate on


// synthesis translate off
`ifdef PLL_FRAC_ABSTRACT
localparam using_khz                    = 1;
`else
localparam using_khz                    =   ( fractional_vco_multiplier == "false" ) ? 1 :
											use_khz_values
											(
                                                output_clock_frequency0,
                                                output_clock_frequency1,
                                                output_clock_frequency2,
                                                output_clock_frequency3,
                                                output_clock_frequency4,
                                                output_clock_frequency5,
                                                output_clock_frequency6,
                                                output_clock_frequency7,
                                                output_clock_frequency8,
                                                output_clock_frequency9,
                                                output_clock_frequency10,
                                                output_clock_frequency11,
                                                output_clock_frequency12,
                                                output_clock_frequency13,
                                                output_clock_frequency14,
                                                output_clock_frequency15,
                                                output_clock_frequency16,
                                                output_clock_frequency17,
                                                number_of_clocks,
												reference_clock_frequency
											);
`endif

localparam MAX_STRING_LENGTH             = 20;
localparam pll_frequency_parameter		= compute_pll_frequency
                                            (
                                                output_clock_frequency0,
                                                output_clock_frequency1,
                                                output_clock_frequency2,
                                                output_clock_frequency3,
                                                output_clock_frequency4,
                                                output_clock_frequency5,
                                                output_clock_frequency6,
                                                output_clock_frequency7,
                                                output_clock_frequency8,
                                                output_clock_frequency9,
                                                output_clock_frequency10,
                                                output_clock_frequency11,
                                                output_clock_frequency12,
                                                output_clock_frequency13,
                                                output_clock_frequency14,
                                                output_clock_frequency15,
                                                output_clock_frequency16,
                                                output_clock_frequency17,
                                                number_of_clocks,
												reference_clock_frequency,
												using_khz
                                            );

localparam use_old_model                = is_period(output_clock_frequency0);

// synthesis translate on



//wire
//Signals needed for Ext DPS ports mode
wire final_phase_en;
wire dps_atpgmode;
wire dps_mdio_dis;
wire dps_scanen;
wire dps_ser_shift_load;
wire dps_write/*synthesis keep*/;
wire [5:0] dps_address;
wire [1:0] dps_byteen;
wire [15:0] dps_writedata/*synthesis keep*/;
        
////////////////////////////////////////
wire [63:0] reconfig_from_pll_wire;
wire [ number_of_clocks -1 :0] fboutclk_wire;
wire [ number_of_clocks -1 :0] locked_wire;
wire [ number_of_clocks -1 :0] outclk_wire;
wire [ number_of_clocks -1 :0] divclk_wire;
wire lvds_fbclk;
wire fb_clkin;
wire fb_out_clk;
wire fb_obuf_clk;
wire [1:0] clkbad_wire;
wire activeclk_wire;
wire [7:0] phout_wire;
wire [ number_of_clocks -1 : 0] cascade_out_wire;
wire [4:0] cntsel_temp /*synthesis keep*/; 	// Need this to prevent input port from synthesized away.
wire [4:0] cntsel_int ;  					// For DPS-only mode, we want lcells in the IP for counter rotation
wire gnd;

assign cntsel_temp = cntsel;
assign gnd = 1'b0;

// synthesis translate off
integer pll_frequency_int;
wire pll_clock;


// ui
reg different_format_error;


// output clocks
reg  [8*MAX_STRING_LENGTH:1] output_clock_frequency_parameter[number_of_clocks -1 :0];

// precision control
reg ref_specified_as_period;
reg out_specified_as_period;
integer output_clock_frequency_value[ number_of_clocks -1 :0];

integer counter_N;
integer counter_M;
integer counter_C[ number_of_clocks -1 :0];
integer count_up_to_C[ number_of_clocks -1 :0];

integer common_freq;
integer current_lcm;

integer ii;

reg [8*MAX_STRING_LENGTH:1] phase_shift_parameter[MAX_NUMBER_OF_CLOCKS-1:0];
real phase_shift_value[MAX_NUMBER_OF_CLOCKS-1:0];

integer duty_cycle_parameter[MAX_NUMBER_OF_CLOCKS-1:0];

real duty_cycle_hi[MAX_NUMBER_OF_CLOCKS-1:0];
real tmp_period;

// outputs
reg [ number_of_clocks -1 :0] outclk_reg;
reg [ number_of_clocks -1 :0] outclk_reg_phase;

integer adjusted_pll_freq_param;

// synthesis translate on



// synthesis translate off
initial
begin
    if ( pll_frequency_parameter == -1 )
    begin
        // call again to get the error msg
		pll_frequency_int		= compute_pll_frequency
                                              (
                                                      output_clock_frequency0,
                                                    output_clock_frequency1,
                                                    output_clock_frequency2,
                                                    output_clock_frequency3,
                                                    output_clock_frequency4,
                                                    output_clock_frequency5,
                                                    output_clock_frequency6,
                                                    output_clock_frequency7,
                                                    output_clock_frequency8,
                                                    output_clock_frequency9,
                                                    output_clock_frequency10,
                                                    output_clock_frequency11,
                                                    output_clock_frequency12,
                                                    output_clock_frequency13,
                                                    output_clock_frequency14,
                                                    output_clock_frequency15,
                                                    output_clock_frequency16,
                                                    output_clock_frequency17,
                                                    number_of_clocks,
													reference_clock_frequency,
													using_khz
                                              );
        $finish;
    end



    // copy all parameters to arrays
    output_clock_frequency_parameter[0] = output_clock_frequency0;
    output_clock_frequency_parameter[1] = output_clock_frequency1;
    output_clock_frequency_parameter[2] = output_clock_frequency2;
    output_clock_frequency_parameter[3] = output_clock_frequency3;
    output_clock_frequency_parameter[4] = output_clock_frequency4;
    output_clock_frequency_parameter[5] = output_clock_frequency5;
    output_clock_frequency_parameter[6] = output_clock_frequency6;
    output_clock_frequency_parameter[7] = output_clock_frequency7;
    output_clock_frequency_parameter[8] = output_clock_frequency8;
    output_clock_frequency_parameter[9] = output_clock_frequency9;
    output_clock_frequency_parameter[10] = output_clock_frequency10;
    output_clock_frequency_parameter[11] = output_clock_frequency11;
    output_clock_frequency_parameter[12] = output_clock_frequency12;
    output_clock_frequency_parameter[13] = output_clock_frequency13;
    output_clock_frequency_parameter[14] = output_clock_frequency14;
    output_clock_frequency_parameter[15] = output_clock_frequency15;
    output_clock_frequency_parameter[16] = output_clock_frequency16;
    output_clock_frequency_parameter[17] = output_clock_frequency17;
    

    phase_shift_parameter[0] = phase_shift0;
    phase_shift_parameter[1] = phase_shift1;
    phase_shift_parameter[2] = phase_shift2;
    phase_shift_parameter[3] = phase_shift3;
    phase_shift_parameter[4] = phase_shift4;
    phase_shift_parameter[5] = phase_shift5;
    phase_shift_parameter[6] = phase_shift6;
    phase_shift_parameter[7] = phase_shift7;
    phase_shift_parameter[8] = phase_shift8;
    phase_shift_parameter[9] = phase_shift9;
    phase_shift_parameter[10] = phase_shift10;
    phase_shift_parameter[11] = phase_shift11;
    phase_shift_parameter[12] = phase_shift12;
    phase_shift_parameter[13] = phase_shift13;
    phase_shift_parameter[14] = phase_shift14;
    phase_shift_parameter[15] = phase_shift15;
    phase_shift_parameter[16] = phase_shift16;
    phase_shift_parameter[17] = phase_shift17;


    duty_cycle_parameter[0] = duty_cycle0;
    duty_cycle_parameter[1] = duty_cycle1;
    duty_cycle_parameter[2] = duty_cycle2;
    duty_cycle_parameter[3] = duty_cycle3;
    duty_cycle_parameter[4] = duty_cycle4;
    duty_cycle_parameter[5] = duty_cycle5;
    duty_cycle_parameter[6] = duty_cycle6;
    duty_cycle_parameter[7] = duty_cycle7;
    duty_cycle_parameter[8] = duty_cycle8;
    duty_cycle_parameter[9] = duty_cycle9;
    duty_cycle_parameter[10] = duty_cycle10;
    duty_cycle_parameter[11] = duty_cycle11;
    duty_cycle_parameter[12] = duty_cycle12;
    duty_cycle_parameter[13] = duty_cycle13;
    duty_cycle_parameter[14] = duty_cycle14;
    duty_cycle_parameter[15] = duty_cycle15;
    duty_cycle_parameter[16] = duty_cycle16;
    duty_cycle_parameter[17] = duty_cycle17;


    // we need to have both frequency and period
    if ( is_period(reference_clock_frequency) )
        ref_specified_as_period = 1;
    else
        ref_specified_as_period = 0;

    // Any input parameter format mismatch is already taken care of, so we only need to look at the
    // first parameter
    if ( is_period(output_clock_frequency_parameter[0]) )
        out_specified_as_period = 1;    
    else
        out_specified_as_period = 0;

        
	adjusted_pll_freq_param = (using_khz) ? (pll_frequency_parameter*1000) : pll_frequency_parameter;


    if (out_specified_as_period == 0 && ref_specified_as_period == 0 )
    begin
        for ( ii = 0; ii < number_of_clocks; ii = ii + 1 )
        begin
            output_clock_frequency_value[ii] = get_frequency_value(output_clock_frequency_parameter[ii]);
            counter_C[ii] =  rounded_division(adjusted_pll_freq_param,output_clock_frequency_value[ii]);
        end
    end
    else if (out_specified_as_period == 0)
    begin
        $display("Error: Output clock frequency is specified in Hz and reference clock in secs");
        $display("Please specify both either as frequencies or as time periods.");
        $finish;
    end

    for ( ii = 0; ii < number_of_clocks; ii = ii + 1 )
    begin
        count_up_to_C[ii] = 0;
        outclk_reg[ii] = 0;
    end


    for ( ii = 0; ii < MAX_NUMBER_OF_CLOCKS && ii < number_of_clocks; ii = ii + 1)
        phase_shift_value[ii] = get_phase_shift_value(phase_shift_parameter[ii],output_clock_frequency_parameter[ii]);


    for ( ii = 0; ii < MAX_NUMBER_OF_CLOCKS && ii < number_of_clocks; ii = ii + 1)
    begin
        // this is an inaccurate computation that will be used only if the duty cycle is not 50
        tmp_period = get_real_value(output_clock_frequency_parameter[ii]);
        duty_cycle_hi[ii] = duty_cycle_parameter[ii]*tmp_period / 100;
        if ( duty_cycle_parameter[ii] != 50 && counter_C[ii] != 1 )
        begin
            counter_C[ii] = 2 * counter_C[ii];
        end
    end

end

// synthesis translate on
assign reconfig_from_pll_wire[63:18] = 0;

generate 
    
    if (pll_type != "General")
    begin
        `define RECONFIGURABLE
        if (pll_subtype == "DPS" || pll_subtype == "General") 
        begin
            //don't assing phase done and locked zeros
            assign reconfig_from_pll_wire[15:0]= 0;
        end
    end
        
endgenerate 



generate
genvar i;  
    if (pll_type == "General" 
    // synthesis translate off
    && use_old_model == 1
    // synthesis translate on
    )
    for (i=0; i<=number_of_clocks-1; i = i +1)
    begin : general
    generic_pll #(
                .reference_clock_frequency(reference_clock_frequency),
				.fractional_vco_multiplier(fractional_vco_multiplier),
                .sim_additional_refclk_cycles_to_lock(sim_additional_refclk_cycles_to_lock),
                .output_clock_frequency((i == 0) ? output_clock_frequency0 : 
                                    (i == 1) ? output_clock_frequency1 :
                                    (i == 2) ? output_clock_frequency2 :
                                    (i == 3) ? output_clock_frequency3 :
                                    (i == 4) ? output_clock_frequency4 :
                                    (i == 5) ? output_clock_frequency5 :
                                    (i == 6) ? output_clock_frequency6 :
                                    (i == 7) ? output_clock_frequency7 :
                                    (i == 8) ? output_clock_frequency8 :
                                    (i == 9) ? output_clock_frequency9 :
                                    (i == 10) ? output_clock_frequency10 :
                                    (i == 11) ? output_clock_frequency11 :
                                    (i == 12) ? output_clock_frequency12 :
                                    (i == 13) ? output_clock_frequency13 :
                                    (i == 14) ? output_clock_frequency14 :
                                    (i == 15) ? output_clock_frequency15 :
                                    (i == 16) ? output_clock_frequency16 : output_clock_frequency17), 
                .duty_cycle((i == 0) ? duty_cycle0 : 
                        (i == 1) ? duty_cycle1 :
                        (i == 2) ? duty_cycle2 :
                        (i == 3) ? duty_cycle3 :
                        (i == 4) ? duty_cycle4 :
                        (i == 5) ? duty_cycle5 :
                        (i == 6) ? duty_cycle6 :
                        (i == 7) ? duty_cycle7 :
                        (i == 8) ? duty_cycle8 :
                        (i == 9) ? duty_cycle9 :
                        (i == 10) ? duty_cycle10 :
                        (i == 11) ? duty_cycle11 :
                        (i == 12) ? duty_cycle12 :
                        (i == 13) ? duty_cycle13 :
                        (i == 14) ? duty_cycle14 :
                        (i == 15) ? duty_cycle15 :
                        (i == 16) ? duty_cycle16 : duty_cycle17), 
            .phase_shift((i == 0) ? phase_shift0 : 
                            (i == 1) ? phase_shift1 :
                            (i == 2) ? phase_shift2 :
                            (i == 3) ? phase_shift3 :
                            (i == 4) ? phase_shift4 :
                            (i == 5) ? phase_shift5 :
                            (i == 6) ? phase_shift6 :
                            (i == 7) ? phase_shift7 :
                            (i == 8) ? phase_shift8 :
                            (i == 9) ? phase_shift9 :
                            (i == 10) ? phase_shift10 :
                            (i == 11) ? phase_shift11 :
                            (i == 12) ? phase_shift12 :
                            (i == 13) ? phase_shift13 :
                            (i == 14) ? phase_shift14 :
                            (i == 15) ? phase_shift15 :
                            (i == 16) ? phase_shift16 : phase_shift17)
    ) gpll (
                     .refclk(refclk),
                     .fbclk((operation_mode == "external feedback") ? fb_clkin : (operation_mode == "zero delay buffer") ? fb_out_clk : fboutclk_wire[0]),
                     .rst(rst),
                     .fboutclk(fboutclk_wire[i]),
                     .outclk(outclk_wire[i]),
                     .locked(locked_wire[i])
                 );
    end  

    `ifdef RECONFIGURABLE
    else 
    begin    
        dps_extra_kick dps_extra_inst(
            .clk(pll_subtype != "General" ? ((pll_subtype == "DPS") ? scanclk : reconfig_to_pll[0]) : 1'b0),
            .reset(rst),
            .phase_done(reconfig_from_pll_wire[17]),
            .usr_phase_en(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? phase_en:reconfig_to_pll[30]) : 1'b0),
            .phase_en(final_phase_en));

        dprio_init dprio_init_inst (
            .clk(scanclk),
            .reset_n(~rst),
            .dprio_address(dps_address),
            .dprio_byteen(dps_byteen),
            .dprio_write(dps_write),
            .dprio_writedata(dps_writedata),

            .atpgmode(dps_atpgmode),
            .mdio_dis(dps_mdio_dis),
            .scanen(dps_scanen),
            .ser_shift_load(dps_ser_shift_load));

        if (pll_type == "Stratix V")
        begin 

            //cnt select luts (5)
            pll_dps_lcell_comb lcell_cntsel_int_0 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[0]));
            defparam lcell_cntsel_int_0.lut_mask = 64'hAAAAAAAAAAAAAAAA;
            defparam lcell_cntsel_int_0.dont_touch = "on";
            defparam lcell_cntsel_int_0.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_1 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[1]));
            defparam lcell_cntsel_int_1.lut_mask = 64'hCCCCCCCCCCCCCCCC;
            defparam lcell_cntsel_int_1.dont_touch = "on";
            defparam lcell_cntsel_int_1.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_2 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[2]));
            defparam lcell_cntsel_int_2.lut_mask = 64'hF0F0F0F0F0F0F0F0;
            defparam lcell_cntsel_int_2.dont_touch = "on";
            defparam lcell_cntsel_int_2.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_3 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[3]));
            defparam lcell_cntsel_int_3.lut_mask = 64'hFF00FF00FF00FF00;
            defparam lcell_cntsel_int_3.dont_touch = "on";
            defparam lcell_cntsel_int_3.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_4 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[4]));
            defparam lcell_cntsel_int_4.lut_mask = 64'hFFFF0000FFFF0000;
            defparam lcell_cntsel_int_4.dont_touch = "on";
            defparam lcell_cntsel_int_4.family = pll_type;
   
            altera_stratixv_pll #(
                .number_of_fplls(1),
                .pll_vco_div_0(pll_vco_div),
                .reference_clock_frequency_0 (reference_clock_frequency),
                .pll_output_clock_frequency_0 (pll_output_clk_frequency),
                .dpa_output_clock_frequency_0 (pll_output_clk_frequency),
                .enable_output_counter_0 ((number_of_clocks >= 1) ? "true" : "false"),
                .enable_output_counter_1 ((number_of_clocks >= 2) ? "true" : "false"),
                .enable_output_counter_2 ((number_of_clocks >= 3) ? "true" : "false"),
                .enable_output_counter_3 ((number_of_clocks >= 4) ? "true" : "false"),
                .enable_output_counter_4 ((number_of_clocks >= 5) ? "true" : "false"),
                .enable_output_counter_5 ((number_of_clocks >= 6) ? "true" : "false"),
                .enable_output_counter_6 ((number_of_clocks >= 7) ? "true" : "false"),
                .enable_output_counter_7 ((number_of_clocks >= 8) ? "true" : "false"),
                .enable_output_counter_8 ((number_of_clocks >= 9) ? "true" : "false"),
                .enable_output_counter_9 ((number_of_clocks >= 10) ? "true" : "false"),
                .enable_output_counter_10 ((number_of_clocks >= 11) ? "true" : "false"),
                .enable_output_counter_11 ((number_of_clocks >= 12) ? "true" : "false"),
                .enable_output_counter_12 ((number_of_clocks >= 13) ? "true" : "false"),
                .enable_output_counter_13 ((number_of_clocks >= 14) ? "true" : "false"),
                .enable_output_counter_14 ((number_of_clocks >= 15) ? "true" : "false"),
                .enable_output_counter_15 ((number_of_clocks >= 16) ? "true" : "false"),
                .enable_output_counter_16 ((number_of_clocks >= 17) ? "true" : "false"),
                .enable_output_counter_17 ((number_of_clocks >= 18) ? "true" : "false"),
                .number_of_extclks ((operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? 1 : 0),
                .enable_extclk_output_0 ((operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? "true" : "false"),
                .number_of_counters(number_of_clocks),
                .pll_dsm_out_sel_0((fractional_vco_multiplier == "true") ? pll_dsm_out_sel : "disable"),
                .pll_dsm_dither_0((fractional_vco_multiplier == "true") ? "disable" : "disable"),
                .pll_cp_current_0 (pll_cp_current),
                .pll_fractional_division_0 (pll_fractional_division),
                .pll_fractional_carry_out_0 (pll_fractional_cout),
                .pll_bwctrl_0 (pll_bwctrl),
                .mimic_fbclk_type_0 (mimic_fbclk_type),
                .pll_fbclk_mux_1_0 (pll_fbclk_mux_1),
                .pll_fbclk_mux_2_0 (pll_fbclk_mux_2),
                .pll_m_cnt_in_src_0 (pll_m_cnt_in_src),
                .pll_m_cnt_hi_div_0(m_cnt_hi_div),
                .pll_m_cnt_lo_div_0 (m_cnt_lo_div),
                .pll_m_cnt_bypass_en_0 (m_cnt_bypass_en),
                .pll_m_cnt_odd_div_duty_en_0 (m_cnt_odd_div_duty_en),
                .pll_n_cnt_hi_div_0 (n_cnt_hi_div),
                .pll_n_cnt_lo_div_0 (n_cnt_lo_div),
                .pll_n_cnt_bypass_en_0 (n_cnt_bypass_en),
                .pll_n_cnt_odd_div_duty_en_0 (n_cnt_odd_div_duty_en),
                .output_clock_frequency_0 (output_clock_frequency0),
				.phase_shift_0(phase_shift0),
                .dprio0_cnt_hi_div_0 (c_cnt_hi_div0), 
                .dprio0_cnt_lo_div_0 (c_cnt_lo_div0),
                .dprio0_cnt_bypass_en_0 (c_cnt_bypass_en0),
                .dprio0_cnt_odd_div_even_duty_en_0 (c_cnt_odd_div_duty_en0),
                .c_cnt_prst_0 (c_cnt_prst0),
                .c_cnt_ph_mux_prst_0 (c_cnt_ph_mux_prst0),
                .output_clock_frequency_1 (output_clock_frequency1),
				.phase_shift_1(phase_shift1),
                .dprio0_cnt_hi_div_1 (c_cnt_hi_div1), 
                .dprio0_cnt_lo_div_1 (c_cnt_lo_div1),
                .dprio0_cnt_bypass_en_1 (c_cnt_bypass_en1),
                .dprio0_cnt_odd_div_even_duty_en_1 (c_cnt_odd_div_duty_en1),
                .c_cnt_prst_1 (c_cnt_prst1),
                .c_cnt_ph_mux_prst_1 (c_cnt_ph_mux_prst1),
                .output_clock_frequency_2 (output_clock_frequency2),
				.phase_shift_2(phase_shift2),
                .dprio0_cnt_hi_div_2 (c_cnt_hi_div2), 
                .dprio0_cnt_lo_div_2 (c_cnt_lo_div2),
                .dprio0_cnt_bypass_en_2 (c_cnt_bypass_en2),
                .dprio0_cnt_odd_div_even_duty_en_2 (c_cnt_odd_div_duty_en2),
                .c_cnt_prst_2 (c_cnt_prst2),
                .c_cnt_ph_mux_prst_2 (c_cnt_ph_mux_prst2),
                .output_clock_frequency_3 (output_clock_frequency3),
				.phase_shift_3(phase_shift3),
                .dprio0_cnt_hi_div_3 (c_cnt_hi_div3), 
                .dprio0_cnt_lo_div_3 (c_cnt_lo_div3),
                .dprio0_cnt_bypass_en_3 (c_cnt_bypass_en3),
                .dprio0_cnt_odd_div_even_duty_en_3 (c_cnt_odd_div_duty_en3),
                .c_cnt_prst_3 (c_cnt_prst3),
                .c_cnt_ph_mux_prst_3 (c_cnt_ph_mux_prst3),
                .output_clock_frequency_4 (output_clock_frequency4),
				.phase_shift_4(phase_shift4),
                .dprio0_cnt_hi_div_4 (c_cnt_hi_div4), 
                .dprio0_cnt_lo_div_4 (c_cnt_lo_div4),
                .dprio0_cnt_bypass_en_4 (c_cnt_bypass_en4),
                .dprio0_cnt_odd_div_even_duty_en_4 (c_cnt_odd_div_duty_en4),
                .c_cnt_prst_4 (c_cnt_prst4),
                .c_cnt_ph_mux_prst_4 (c_cnt_ph_mux_prst4),
                .output_clock_frequency_5 (output_clock_frequency5),
				.phase_shift_5(phase_shift5),
                .dprio0_cnt_hi_div_5 (c_cnt_hi_div5), 
                .dprio0_cnt_lo_div_5 (c_cnt_lo_div5),
                .dprio0_cnt_bypass_en_5 (c_cnt_bypass_en5),
                .dprio0_cnt_odd_div_even_duty_en_5 (c_cnt_odd_div_duty_en5),
                .c_cnt_prst_5 (c_cnt_prst5),
                .c_cnt_ph_mux_prst_5 (c_cnt_ph_mux_prst5),
                .output_clock_frequency_6 (output_clock_frequency6),
				.phase_shift_6(phase_shift6),
                .dprio0_cnt_hi_div_6 (c_cnt_hi_div6), 
                .dprio0_cnt_lo_div_6 (c_cnt_lo_div6),
                .dprio0_cnt_bypass_en_6 (c_cnt_bypass_en6),
                .dprio0_cnt_odd_div_even_duty_en_6 (c_cnt_odd_div_duty_en6),
                .c_cnt_prst_6 (c_cnt_prst6),
                .c_cnt_ph_mux_prst_6 (c_cnt_ph_mux_prst6),
                .output_clock_frequency_7 (output_clock_frequency7),
				.phase_shift_7(phase_shift7),
                .dprio0_cnt_hi_div_7 (c_cnt_hi_div7), 
                .dprio0_cnt_lo_div_7 (c_cnt_lo_div7),
                .dprio0_cnt_bypass_en_7 (c_cnt_bypass_en7),
                .dprio0_cnt_odd_div_even_duty_en_7 (c_cnt_odd_div_duty_en7),
                .c_cnt_prst_7 (c_cnt_prst7),
                .c_cnt_ph_mux_prst_7 (c_cnt_ph_mux_prst7),
                .output_clock_frequency_8 (output_clock_frequency8),
				.phase_shift_8(phase_shift8),
                .dprio0_cnt_hi_div_8 (c_cnt_hi_div8), 
                .dprio0_cnt_lo_div_8 (c_cnt_lo_div8),
                .dprio0_cnt_bypass_en_8 (c_cnt_bypass_en8),
                .dprio0_cnt_odd_div_even_duty_en_8 (c_cnt_odd_div_duty_en8),
                .c_cnt_prst_8 (c_cnt_prst8),
                .c_cnt_ph_mux_prst_8 (c_cnt_ph_mux_prst8),
                .output_clock_frequency_9 (output_clock_frequency9),
				.phase_shift_9(phase_shift9),
                .dprio0_cnt_hi_div_9 (c_cnt_hi_div9), 
                .dprio0_cnt_lo_div_9 (c_cnt_lo_div9),
                .dprio0_cnt_bypass_en_9 (c_cnt_bypass_en9),
                .dprio0_cnt_odd_div_even_duty_en_9 (c_cnt_odd_div_duty_en9),
                .c_cnt_prst_9 (c_cnt_prst9),
                .c_cnt_ph_mux_prst_9 (c_cnt_ph_mux_prst9),
                .output_clock_frequency_10 (output_clock_frequency10),
				.phase_shift_10(phase_shift10),
                .dprio0_cnt_hi_div_10 (c_cnt_hi_div10), 
                .dprio0_cnt_lo_div_10 (c_cnt_lo_div10),
                .dprio0_cnt_bypass_en_10 (c_cnt_bypass_en10),
                .dprio0_cnt_odd_div_even_duty_en_10 (c_cnt_odd_div_duty_en10),
                .c_cnt_prst_10 (c_cnt_prst10),
                .c_cnt_ph_mux_prst_10 (c_cnt_ph_mux_prst10),
                .output_clock_frequency_11 (output_clock_frequency11),
				.phase_shift_11(phase_shift11),
                .dprio0_cnt_hi_div_11 (c_cnt_hi_div11), 
                .dprio0_cnt_lo_div_11 (c_cnt_lo_div11),
                .dprio0_cnt_bypass_en_11 (c_cnt_bypass_en11),
                .dprio0_cnt_odd_div_even_duty_en_11 (c_cnt_odd_div_duty_en11),
                .c_cnt_prst_11 (c_cnt_prst11),
                .c_cnt_ph_mux_prst_11 (c_cnt_ph_mux_prst11),
                .output_clock_frequency_12 (output_clock_frequency12),
				.phase_shift_12(phase_shift12),
                .dprio0_cnt_hi_div_12 (c_cnt_hi_div12), 
                .dprio0_cnt_lo_div_12 (c_cnt_lo_div12),
                .dprio0_cnt_bypass_en_12 (c_cnt_bypass_en12),
                .dprio0_cnt_odd_div_even_duty_en_12 (c_cnt_odd_div_duty_en12),
                .c_cnt_prst_12 (c_cnt_prst12),
                .c_cnt_ph_mux_prst_12 (c_cnt_ph_mux_prst12),
                .output_clock_frequency_13 (output_clock_frequency13),
				.phase_shift_13(phase_shift13),
                .dprio0_cnt_hi_div_13 (c_cnt_hi_div13), 
                .dprio0_cnt_lo_div_13 (c_cnt_lo_div13),
                .dprio0_cnt_bypass_en_13 (c_cnt_bypass_en13),
                .dprio0_cnt_odd_div_even_duty_en_13 (c_cnt_odd_div_duty_en13),
                .c_cnt_prst_13 (c_cnt_prst13),
                .c_cnt_ph_mux_prst_13 (c_cnt_ph_mux_prst13),
                .output_clock_frequency_14 (output_clock_frequency14),
				.phase_shift_14(phase_shift14),
                .dprio0_cnt_hi_div_14 (c_cnt_hi_div14), 
                .dprio0_cnt_lo_div_14 (c_cnt_lo_div14),
                .dprio0_cnt_bypass_en_14 (c_cnt_bypass_en14),
                .dprio0_cnt_odd_div_even_duty_en_14 (c_cnt_odd_div_duty_en14),
                .c_cnt_prst_14 (c_cnt_prst14),
                .c_cnt_ph_mux_prst_14 (c_cnt_ph_mux_prst14),
                .output_clock_frequency_15 (output_clock_frequency15),
				.phase_shift_15(phase_shift15),
                .dprio0_cnt_hi_div_15 (c_cnt_hi_div15), 
                .dprio0_cnt_lo_div_15 (c_cnt_lo_div15),
                .dprio0_cnt_bypass_en_15 (c_cnt_bypass_en15),
                .dprio0_cnt_odd_div_even_duty_en_15 (c_cnt_odd_div_duty_en15),
                .c_cnt_prst_15 (c_cnt_prst15),
                .c_cnt_ph_mux_prst_15 (c_cnt_ph_mux_prst15),
                .output_clock_frequency_16 (output_clock_frequency16),
				.phase_shift_16(phase_shift16),
                .dprio0_cnt_hi_div_16 (c_cnt_hi_div16), 
                .dprio0_cnt_lo_div_16 (c_cnt_lo_div16),
                .dprio0_cnt_bypass_en_16 (c_cnt_bypass_en16),
                .dprio0_cnt_odd_div_even_duty_en_16 (c_cnt_odd_div_duty_en16),
                .c_cnt_prst_16 (c_cnt_prst16),
                .c_cnt_ph_mux_prst_16 (c_cnt_ph_mux_prst16),
                .output_clock_frequency_17 (output_clock_frequency17),
				.phase_shift_17(phase_shift17),
                .dprio0_cnt_hi_div_17 (c_cnt_hi_div17), 
                .dprio0_cnt_lo_div_17 (c_cnt_lo_div17),
                .dprio0_cnt_bypass_en_17 (c_cnt_bypass_en17),
                .dprio0_cnt_odd_div_even_duty_en_17 (c_cnt_odd_div_duty_en17),
                .c_cnt_prst_17 (c_cnt_prst17),
                .c_cnt_ph_mux_prst_17 (c_cnt_ph_mux_prst17),
                //output counter cascading params
                .c_cnt_in_src_0 (c_cnt_in_src0),
                .c_cnt_in_src_1 (c_cnt_in_src1),
                .c_cnt_in_src_2 (c_cnt_in_src2),
                .c_cnt_in_src_3 (c_cnt_in_src3),
                .c_cnt_in_src_4 (c_cnt_in_src4),
                .c_cnt_in_src_5 (c_cnt_in_src5),
                .c_cnt_in_src_6 (c_cnt_in_src6),
                .c_cnt_in_src_7 (c_cnt_in_src7),
                .c_cnt_in_src_8 (c_cnt_in_src8),
                .c_cnt_in_src_9 (c_cnt_in_src9),
                .c_cnt_in_src_10 (c_cnt_in_src10),
                .c_cnt_in_src_11 (c_cnt_in_src11),
                .c_cnt_in_src_12 (c_cnt_in_src12),
                .c_cnt_in_src_13 (c_cnt_in_src13),
                .c_cnt_in_src_14 (c_cnt_in_src14),
                .c_cnt_in_src_15 (c_cnt_in_src15),
                .c_cnt_in_src_16 (c_cnt_in_src16),
                .c_cnt_in_src_17 (c_cnt_in_src17),
                //refclk select params
                .pll_auto_clk_sw_en_0 (pll_auto_clk_sw_en),
                .pll_clk_loss_sw_en_0 (pll_clk_loss_sw_en),
                .pll_clk_sw_dly_0    (pll_clk_sw_dly),
                .pll_clkin_0_src_0   (pll_clkin_0_src),
                .pll_clkin_1_src_0   (pll_clkin_1_src),
                .pll_manu_clk_sw_en_0  (pll_manu_clk_sw_en)
        )

             stratixv_pll (
                // stratixv_pll_dpa_output pins
                .phout_0(phout_wire),
                .phout_1(),
                
                // stratixv_pll_refclk_select pins
                .adjpllin(adjpllin),    
                .cclk(cclk),
                .coreclkin(),
                .extswitch(extswitch),
                .iqtxrxclkin(),
                .plliqclkin(),
                .rxiqclkin(),
                .clkin({2'b0,refclk1, refclk}),
                .refiqclk_0(),
                .refiqclk_1(),
                .clk0bad(clkbad_wire[0]),
                .clk1bad(clkbad_wire[1]),
                .pllclksel(activeclk_wire),

                // stratixv_pll_reconfig pins
                .atpgmode(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_atpgmode : reconfig_to_pll[38]) : 1'b0),
                .clk(pll_subtype != "General" ? ((pll_subtype == "DPS") ? scanclk : reconfig_to_pll[0]) : 1'b0),
                .fpllcsrtest(reconfig_to_pll[38]),
                .iocsrclkin(),
                .iocsrdatain(),
                .iocsren(),
                .iocsrrstn(),
                .mdiodis(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_mdio_dis: reconfig_to_pll[29]) : 1'b1),
                .phaseen(final_phase_en),
                .read(reconfig_to_pll[3]),
                .rstn(pll_subtype != "General" ? ((pll_subtype == "DPS") ? ~rst : reconfig_to_pll[1]): 1'b1),
                .scanen(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_scanen : reconfig_to_pll[37]) : 1'b0),
                .sershiftload(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_ser_shift_load : reconfig_to_pll[28]) : 1'b1),
                .shiftdonei(),
                .updn(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? updn:reconfig_to_pll[31]) : 1'b0),
                .write(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_write : reconfig_to_pll[2]) :1'b0),
                .addr_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_address : reconfig_to_pll[9:4]) :6'b000000),
                .addr_1(),
                .byteen_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_byteen : reconfig_to_pll[27:26]) :2'b00),
                .byteen_1(),
                .cntsel_0(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? cntsel_int:reconfig_to_pll[36:32]) : 5'b00000),
                .cntsel_1(),
                .din_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_writedata : reconfig_to_pll[25:10]) :16'h0000),
                .din_1(),
                .blockselect(),
                .iocsrdataout(),
                .iocsrenbuf(),
                .iocsrrstnbuf(),
                .phasedone(reconfig_from_pll_wire[17]),
                .dout_0(reconfig_from_pll_wire[15:0]),
                .dout_1(),
                .dprioout_0(),
                .dprioout_1(),
                
                // stratixv_fractional_pll pins
                .fbclkfpll(),
                .lvdfbin((operation_mode == "lvds") ? lvds_fbclk : 1'b0),
                .nresync(~rst),
                .pfden(1'b1),
                .shiften_fpll(),
                .zdb((operation_mode == "external feedback") ? fb_clkin : (operation_mode == "zero delay buffer") ? fb_out_clk : 1'b0),
                .fblvdsout(lvds_fbclk),
                .lock(reconfig_from_pll_wire[16]),
                .mcntout(),
                .plniotribuf(),

                // stratixv_pll_extclk_output pins
                .clken(),
                .extclk(fboutclk_wire[0]),

                // stratixv_pll_dll_output pins
                .dll_clkin(),
                .clkout(),

                // stratixv_pll_lvds_output pins
                .loaden(),
                .lvdsclk(),

                // stratixv_pll_output_counter pins
                .divclk(divclk_wire),
				.cascade_out(cascade_out_wire)
                );
                
                assign locked_wire[0] = reconfig_from_pll_wire[16]; 
                assign outclk_wire = divclk_wire;
            end
            else if (pll_type == "Arria V") 
            begin    

            //cnt select luts (5)
            pll_dps_lcell_comb lcell_cntsel_int_0 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[0]));
            defparam lcell_cntsel_int_0.lut_mask = 64'hAAAAAAAAAAAAAAAA;
            defparam lcell_cntsel_int_0.dont_touch = "on";
            defparam lcell_cntsel_int_0.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_1 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[1]));
            defparam lcell_cntsel_int_1.lut_mask = 64'hCCCCCCCCCCCCCCCC;
            defparam lcell_cntsel_int_1.dont_touch = "on";
            defparam lcell_cntsel_int_1.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_2 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[2]));
            defparam lcell_cntsel_int_2.lut_mask = 64'hF0F0F0F0F0F0F0F0;
            defparam lcell_cntsel_int_2.dont_touch = "on";
            defparam lcell_cntsel_int_2.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_3 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[3]));
            defparam lcell_cntsel_int_3.lut_mask = 64'hFF00FF00FF00FF00;
            defparam lcell_cntsel_int_3.dont_touch = "on";
            defparam lcell_cntsel_int_3.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_4 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[4]));
            defparam lcell_cntsel_int_4.lut_mask = 64'hFFFF0000FFFF0000;
            defparam lcell_cntsel_int_4.dont_touch = "on";
            defparam lcell_cntsel_int_4.family = pll_type;
   
         
            altera_arriav_pll #(
                .number_of_fplls(1),
                .pll_vco_div_0(pll_vco_div),
                .reference_clock_frequency_0 (reference_clock_frequency),
                .pll_output_clock_frequency_0 (pll_output_clk_frequency),
                .dpa_output_clock_frequency_0 (pll_output_clk_frequency),
                .enable_output_counter_0 ((number_of_clocks >= 1) ? "true" : "false"),
                .enable_output_counter_1 ((number_of_clocks >= 2) ? "true" : "false"),
                .enable_output_counter_2 ((number_of_clocks >= 3) ? "true" : "false"),
                .enable_output_counter_3 ((number_of_clocks >= 4) ? "true" : "false"),
                .enable_output_counter_4 ((number_of_clocks >= 5) ? "true" : "false"),
                .enable_output_counter_5 ((number_of_clocks >= 6) ? "true" : "false"),
                .enable_output_counter_6 ((number_of_clocks >= 7) ? "true" : "false"),
                .enable_output_counter_7 ((number_of_clocks >= 8) ? "true" : "false"),
                .enable_output_counter_8 ((number_of_clocks >= 9) ? "true" : "false"),
                .enable_output_counter_9 ((number_of_clocks >= 10) ? "true" : "false"),
                .enable_output_counter_10 ((number_of_clocks >= 11) ? "true" : "false"),
                .enable_output_counter_11 ((number_of_clocks >= 12) ? "true" : "false"),
                .enable_output_counter_12 ((number_of_clocks >= 13) ? "true" : "false"),
                .enable_output_counter_13 ((number_of_clocks >= 14) ? "true" : "false"),
                .enable_output_counter_14 ((number_of_clocks >= 15) ? "true" : "false"),
                .enable_output_counter_15 ((number_of_clocks >= 16) ? "true" : "false"),
                .enable_output_counter_16 ((number_of_clocks >= 17) ? "true" : "false"),
                .enable_output_counter_17 ((number_of_clocks >= 18) ? "true" : "false"),
                .number_of_extclks ((operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? 1 : 0),
                .enable_extclk_output_0 ((operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? "true" : "false"),
                .number_of_counters(number_of_clocks),
                .pll_dsm_out_sel_0((fractional_vco_multiplier == "true") ? pll_dsm_out_sel : "disable"),
                .pll_dsm_dither_0((fractional_vco_multiplier == "true") ? "disable" : "disable"),
                .pll_cp_current_0 (pll_cp_current),
                .pll_fractional_division_0 (pll_fractional_division),
                .pll_fractional_carry_out_0 (pll_fractional_cout),
                .pll_bwctrl_0 (pll_bwctrl),
                .mimic_fbclk_type_0 (mimic_fbclk_type),
                .pll_fbclk_mux_1_0 (pll_fbclk_mux_1),
                .pll_fbclk_mux_2_0 (pll_fbclk_mux_2),
                .pll_m_cnt_in_src_0 (pll_m_cnt_in_src),
                .pll_m_cnt_hi_div_0(m_cnt_hi_div),
                .pll_m_cnt_lo_div_0 (m_cnt_lo_div),
                .pll_m_cnt_bypass_en_0 (m_cnt_bypass_en),
                .pll_m_cnt_odd_div_duty_en_0 (m_cnt_odd_div_duty_en),
                .pll_n_cnt_hi_div_0 (n_cnt_hi_div),
                .pll_n_cnt_lo_div_0 (n_cnt_lo_div),
                .pll_n_cnt_bypass_en_0 (n_cnt_bypass_en),
                .pll_n_cnt_odd_div_duty_en_0 (n_cnt_odd_div_duty_en),
                .output_clock_frequency_0 (output_clock_frequency0),
				.phase_shift_0(phase_shift0),
                .dprio0_cnt_hi_div_0 (c_cnt_hi_div0), 
                .dprio0_cnt_lo_div_0 (c_cnt_lo_div0),
                .dprio0_cnt_bypass_en_0 (c_cnt_bypass_en0),
                .dprio0_cnt_odd_div_even_duty_en_0 (c_cnt_odd_div_duty_en0),
                .c_cnt_prst_0 (c_cnt_prst0),
                .c_cnt_ph_mux_prst_0 (c_cnt_ph_mux_prst0),
                .output_clock_frequency_1 (output_clock_frequency1),
				.phase_shift_1(phase_shift1),
                .dprio0_cnt_hi_div_1 (c_cnt_hi_div1), 
                .dprio0_cnt_lo_div_1 (c_cnt_lo_div1),
                .dprio0_cnt_bypass_en_1 (c_cnt_bypass_en1),
                .dprio0_cnt_odd_div_even_duty_en_1 (c_cnt_odd_div_duty_en1),
                .c_cnt_prst_1 (c_cnt_prst1),
                .c_cnt_ph_mux_prst_1 (c_cnt_ph_mux_prst1),
                .output_clock_frequency_2 (output_clock_frequency2),
				.phase_shift_2(phase_shift2),
                .dprio0_cnt_hi_div_2 (c_cnt_hi_div2), 
                .dprio0_cnt_lo_div_2 (c_cnt_lo_div2),
                .dprio0_cnt_bypass_en_2 (c_cnt_bypass_en2),
                .dprio0_cnt_odd_div_even_duty_en_2 (c_cnt_odd_div_duty_en2),
                .c_cnt_prst_2 (c_cnt_prst2),
                .c_cnt_ph_mux_prst_2 (c_cnt_ph_mux_prst2),
                .output_clock_frequency_3 (output_clock_frequency3),
				.phase_shift_3(phase_shift3),
                .dprio0_cnt_hi_div_3 (c_cnt_hi_div3), 
                .dprio0_cnt_lo_div_3 (c_cnt_lo_div3),
                .dprio0_cnt_bypass_en_3 (c_cnt_bypass_en3),
                .dprio0_cnt_odd_div_even_duty_en_3 (c_cnt_odd_div_duty_en3),
                .c_cnt_prst_3 (c_cnt_prst3),
                .c_cnt_ph_mux_prst_3 (c_cnt_ph_mux_prst3),
                .output_clock_frequency_4 (output_clock_frequency4),
				.phase_shift_4(phase_shift4),
                .dprio0_cnt_hi_div_4 (c_cnt_hi_div4), 
                .dprio0_cnt_lo_div_4 (c_cnt_lo_div4),
                .dprio0_cnt_bypass_en_4 (c_cnt_bypass_en4),
                .dprio0_cnt_odd_div_even_duty_en_4 (c_cnt_odd_div_duty_en4),
                .c_cnt_prst_4 (c_cnt_prst4),
                .c_cnt_ph_mux_prst_4 (c_cnt_ph_mux_prst4),
                .output_clock_frequency_5 (output_clock_frequency5),
				.phase_shift_5(phase_shift5),
                .dprio0_cnt_hi_div_5 (c_cnt_hi_div5), 
                .dprio0_cnt_lo_div_5 (c_cnt_lo_div5),
                .dprio0_cnt_bypass_en_5 (c_cnt_bypass_en5),
                .dprio0_cnt_odd_div_even_duty_en_5 (c_cnt_odd_div_duty_en5),
                .c_cnt_prst_5 (c_cnt_prst5),
                .c_cnt_ph_mux_prst_5 (c_cnt_ph_mux_prst5),
                .output_clock_frequency_6 (output_clock_frequency6),
				.phase_shift_6(phase_shift6),
                .dprio0_cnt_hi_div_6 (c_cnt_hi_div6), 
                .dprio0_cnt_lo_div_6 (c_cnt_lo_div6),
                .dprio0_cnt_bypass_en_6 (c_cnt_bypass_en6),
                .dprio0_cnt_odd_div_even_duty_en_6 (c_cnt_odd_div_duty_en6),
                .c_cnt_prst_6 (c_cnt_prst6),
                .c_cnt_ph_mux_prst_6 (c_cnt_ph_mux_prst6),
                .output_clock_frequency_7 (output_clock_frequency7),
				.phase_shift_7(phase_shift7),
                .dprio0_cnt_hi_div_7 (c_cnt_hi_div7), 
                .dprio0_cnt_lo_div_7 (c_cnt_lo_div7),
                .dprio0_cnt_bypass_en_7 (c_cnt_bypass_en7),
                .dprio0_cnt_odd_div_even_duty_en_7 (c_cnt_odd_div_duty_en7),
                .c_cnt_prst_7 (c_cnt_prst7),
                .c_cnt_ph_mux_prst_7 (c_cnt_ph_mux_prst7),
                .output_clock_frequency_8 (output_clock_frequency8),
				.phase_shift_8(phase_shift8),
                .dprio0_cnt_hi_div_8 (c_cnt_hi_div8), 
                .dprio0_cnt_lo_div_8 (c_cnt_lo_div8),
                .dprio0_cnt_bypass_en_8 (c_cnt_bypass_en8),
                .dprio0_cnt_odd_div_even_duty_en_8 (c_cnt_odd_div_duty_en8),
                .c_cnt_prst_8 (c_cnt_prst8),
                .c_cnt_ph_mux_prst_8 (c_cnt_ph_mux_prst8),
                .output_clock_frequency_9 (output_clock_frequency9),
				.phase_shift_9(phase_shift9),
                .dprio0_cnt_hi_div_9 (c_cnt_hi_div9), 
                .dprio0_cnt_lo_div_9 (c_cnt_lo_div9),
                .dprio0_cnt_bypass_en_9 (c_cnt_bypass_en9),
                .dprio0_cnt_odd_div_even_duty_en_9 (c_cnt_odd_div_duty_en9),
                .c_cnt_prst_9 (c_cnt_prst9),
                .c_cnt_ph_mux_prst_9 (c_cnt_ph_mux_prst9),
                .output_clock_frequency_10 (output_clock_frequency10),
				.phase_shift_10(phase_shift10),
                .dprio0_cnt_hi_div_10 (c_cnt_hi_div10), 
                .dprio0_cnt_lo_div_10 (c_cnt_lo_div10),
                .dprio0_cnt_bypass_en_10 (c_cnt_bypass_en10),
                .dprio0_cnt_odd_div_even_duty_en_10 (c_cnt_odd_div_duty_en10),
                .c_cnt_prst_10 (c_cnt_prst10),
                .c_cnt_ph_mux_prst_10 (c_cnt_ph_mux_prst10),
                .output_clock_frequency_11 (output_clock_frequency11),
				.phase_shift_11(phase_shift11),
                .dprio0_cnt_hi_div_11 (c_cnt_hi_div11), 
                .dprio0_cnt_lo_div_11 (c_cnt_lo_div11),
                .dprio0_cnt_bypass_en_11 (c_cnt_bypass_en11),
                .dprio0_cnt_odd_div_even_duty_en_11 (c_cnt_odd_div_duty_en11),
                .c_cnt_prst_11 (c_cnt_prst11),
                .c_cnt_ph_mux_prst_11 (c_cnt_ph_mux_prst11),
                .output_clock_frequency_12 (output_clock_frequency12),
				.phase_shift_12(phase_shift12),
                .dprio0_cnt_hi_div_12 (c_cnt_hi_div12), 
                .dprio0_cnt_lo_div_12 (c_cnt_lo_div12),
                .dprio0_cnt_bypass_en_12 (c_cnt_bypass_en12),
                .dprio0_cnt_odd_div_even_duty_en_12 (c_cnt_odd_div_duty_en12),
                .c_cnt_prst_12 (c_cnt_prst12),
                .c_cnt_ph_mux_prst_12 (c_cnt_ph_mux_prst12),
                .output_clock_frequency_13 (output_clock_frequency13),
				.phase_shift_13(phase_shift13),
                .dprio0_cnt_hi_div_13 (c_cnt_hi_div13), 
                .dprio0_cnt_lo_div_13 (c_cnt_lo_div13),
                .dprio0_cnt_bypass_en_13 (c_cnt_bypass_en13),
                .dprio0_cnt_odd_div_even_duty_en_13 (c_cnt_odd_div_duty_en13),
                .c_cnt_prst_13 (c_cnt_prst13),
                .c_cnt_ph_mux_prst_13 (c_cnt_ph_mux_prst13),
                .output_clock_frequency_14 (output_clock_frequency14),
				.phase_shift_14(phase_shift14),
                .dprio0_cnt_hi_div_14 (c_cnt_hi_div14), 
                .dprio0_cnt_lo_div_14 (c_cnt_lo_div14),
                .dprio0_cnt_bypass_en_14 (c_cnt_bypass_en14),
                .dprio0_cnt_odd_div_even_duty_en_14 (c_cnt_odd_div_duty_en14),
                .c_cnt_prst_14 (c_cnt_prst14),
                .c_cnt_ph_mux_prst_14 (c_cnt_ph_mux_prst14),
                .output_clock_frequency_15 (output_clock_frequency15),
				.phase_shift_15(phase_shift15),
                .dprio0_cnt_hi_div_15 (c_cnt_hi_div15), 
                .dprio0_cnt_lo_div_15 (c_cnt_lo_div15),
                .dprio0_cnt_bypass_en_15 (c_cnt_bypass_en15),
                .dprio0_cnt_odd_div_even_duty_en_15 (c_cnt_odd_div_duty_en15),
                .c_cnt_prst_15 (c_cnt_prst15),
                .c_cnt_ph_mux_prst_15 (c_cnt_ph_mux_prst15),
                .output_clock_frequency_16 (output_clock_frequency16),
				.phase_shift_16(phase_shift16),
                .dprio0_cnt_hi_div_16 (c_cnt_hi_div16), 
                .dprio0_cnt_lo_div_16 (c_cnt_lo_div16),
                .dprio0_cnt_bypass_en_16 (c_cnt_bypass_en16),
                .dprio0_cnt_odd_div_even_duty_en_16 (c_cnt_odd_div_duty_en16),
                .c_cnt_prst_16 (c_cnt_prst16),
                .c_cnt_ph_mux_prst_16 (c_cnt_ph_mux_prst16),
                .output_clock_frequency_17 (output_clock_frequency17),
				.phase_shift_17(phase_shift17),
                .dprio0_cnt_hi_div_17 (c_cnt_hi_div17), 
                .dprio0_cnt_lo_div_17 (c_cnt_lo_div17),
                .dprio0_cnt_bypass_en_17 (c_cnt_bypass_en17),
                .dprio0_cnt_odd_div_even_duty_en_17 (c_cnt_odd_div_duty_en17),
                .c_cnt_prst_17 (c_cnt_prst17),
                .c_cnt_ph_mux_prst_17 (c_cnt_ph_mux_prst17),
                //output counter cascading params
                .c_cnt_in_src_0 (c_cnt_in_src0),
                .c_cnt_in_src_1 (c_cnt_in_src1),
                .c_cnt_in_src_2 (c_cnt_in_src2),
                .c_cnt_in_src_3 (c_cnt_in_src3),
                .c_cnt_in_src_4 (c_cnt_in_src4),
                .c_cnt_in_src_5 (c_cnt_in_src5),
                .c_cnt_in_src_6 (c_cnt_in_src6),
                .c_cnt_in_src_7 (c_cnt_in_src7),
                .c_cnt_in_src_8 (c_cnt_in_src8),
                .c_cnt_in_src_9 (c_cnt_in_src9),
                .c_cnt_in_src_10 (c_cnt_in_src10),
                .c_cnt_in_src_11 (c_cnt_in_src11),
                .c_cnt_in_src_12 (c_cnt_in_src12),
                .c_cnt_in_src_13 (c_cnt_in_src13),
                .c_cnt_in_src_14 (c_cnt_in_src14),
                .c_cnt_in_src_15 (c_cnt_in_src15),
                .c_cnt_in_src_16 (c_cnt_in_src16),
                .c_cnt_in_src_17 (c_cnt_in_src17),
                //refclk select params
                .pll_auto_clk_sw_en_0 (pll_auto_clk_sw_en),
                .pll_clk_loss_sw_en_0 (pll_clk_loss_sw_en),
                .pll_clk_sw_dly_0    (pll_clk_sw_dly),
                .pll_clkin_0_src_0   (pll_clkin_0_src),
                .pll_clkin_1_src_0   (pll_clkin_1_src),
                .pll_manu_clk_sw_en_0  (pll_manu_clk_sw_en)
        )

             arriav_pll (
                // arriav_pll_dpa_output pins
                .phout_0(phout_wire),
                .phout_1(),
                
                // arriav_pll_refclk_select pins
                .adjpllin(adjpllin),    
                .cclk(cclk),
                .coreclkin(),
                .extswitch(extswitch),
                .iqtxrxclkin(),
                .plliqclkin(),
                .rxiqclkin(),
                .clkin({2'b0,refclk1, refclk}),
                .refiqclk_0(),
                .refiqclk_1(),
                .clk0bad(clkbad_wire[0]),
                .clk1bad(clkbad_wire[1]),
                .pllclksel(activeclk_wire),

                // arriav_pll_reconfig pins
                .atpgmode(),
                .clk(pll_subtype != "General" ? ((pll_subtype == "DPS") ? scanclk : reconfig_to_pll[0]) : 1'b0),
                .fpllcsrtest(),
                .iocsrclkin(),
                .iocsrdatain(),
                .iocsren(),
                .iocsrrstn(),
                .mdiodis(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_mdio_dis: reconfig_to_pll[29]) : 1'b1),
                .phaseen(final_phase_en),
                .read(reconfig_to_pll[3]),
                .rstn(pll_subtype != "General" ? ((pll_subtype == "DPS") ? ~rst : reconfig_to_pll[1]): 1'b1),
                .scanen(),
                .sershiftload(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_ser_shift_load : reconfig_to_pll[28]) : 1'b1),
                .shiftdonei(),
                .updn(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? updn:reconfig_to_pll[31]) : 1'b0),
                .write(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_write : reconfig_to_pll[2]) :1'b0),
                .addr_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_address : reconfig_to_pll[9:4]) :6'b000000),
                .addr_1(),
                .byteen_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_byteen : reconfig_to_pll[27:26]) :2'b00),
                .byteen_1(),
                .cntsel_0(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? cntsel_int:reconfig_to_pll[36:32]) : 5'b00000),
                .cntsel_1(),
                .din_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_writedata : reconfig_to_pll[25:10]) :16'h0000),
                .din_1(),
                .blockselect(),
                .iocsrdataout(),
                .iocsrenbuf(),
                .iocsrrstnbuf(),
                .phasedone(reconfig_from_pll_wire[17]),
                .dout_0(reconfig_from_pll_wire[15:0]),
                .dout_1(),
                .dprioout_0(),
                .dprioout_1(),
                
                // arriav_fractional_pll pins
                .fbclkfpll(),
                .lvdfbin((operation_mode == "lvds") ? lvds_fbclk : 1'b0),
                .nresync(~rst),
                .pfden(1'b1),
                .shiften_fpll(),
                .zdb((operation_mode == "external feedback") ? fb_clkin : (operation_mode == "zero delay buffer") ? fb_out_clk : 1'b0),
                .fblvdsout(lvds_fbclk),
                .lock(reconfig_from_pll_wire[16]),
                .mcntout(),
                .plniotribuf(),

                // arriav_pll_extclk_output pins
                .clken(),
                .extclk(fboutclk_wire[0]),

                // arriav_pll_dll_output pins
                .dll_clkin(),
                .clkout(),

                // arriav_pll_lvds_output pins
                .loaden(),
                .lvdsclk(),

                // arriav_pll_output_counter pins
                .divclk(divclk_wire),
				.cascade_out(cascade_out_wire)				
                );
                
                assign locked_wire[0] = reconfig_from_pll_wire[16]; 
                assign outclk_wire = divclk_wire;
            end 
			else if (pll_type == "Arria V GZ")
			begin 

            //cnt select luts (5)
            pll_dps_lcell_comb lcell_cntsel_int_0 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[0]));
            defparam lcell_cntsel_int_0.lut_mask = 64'hAAAAAAAAAAAAAAAA;
            defparam lcell_cntsel_int_0.dont_touch = "on";
            defparam lcell_cntsel_int_0.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_1 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[1]));
            defparam lcell_cntsel_int_1.lut_mask = 64'hCCCCCCCCCCCCCCCC;
            defparam lcell_cntsel_int_1.dont_touch = "on";
            defparam lcell_cntsel_int_1.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_2 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[2]));
            defparam lcell_cntsel_int_2.lut_mask = 64'hF0F0F0F0F0F0F0F0;
            defparam lcell_cntsel_int_2.dont_touch = "on";
            defparam lcell_cntsel_int_2.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_3 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[3]));
            defparam lcell_cntsel_int_3.lut_mask = 64'hFF00FF00FF00FF00;
            defparam lcell_cntsel_int_3.dont_touch = "on";
            defparam lcell_cntsel_int_3.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_4 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[4]));
            defparam lcell_cntsel_int_4.lut_mask = 64'hFFFF0000FFFF0000;
            defparam lcell_cntsel_int_4.dont_touch = "on";
            defparam lcell_cntsel_int_4.family = pll_type;
   
            altera_arriavgz_pll #(
                .number_of_fplls(1),
                .pll_vco_div_0(pll_vco_div),
                .reference_clock_frequency_0 (reference_clock_frequency),
                .pll_output_clock_frequency_0 (pll_output_clk_frequency),
                .dpa_output_clock_frequency_0 (pll_output_clk_frequency),
                .enable_output_counter_0 ((number_of_clocks >= 1) ? "true" : "false"),
                .enable_output_counter_1 ((number_of_clocks >= 2) ? "true" : "false"),
                .enable_output_counter_2 ((number_of_clocks >= 3) ? "true" : "false"),
                .enable_output_counter_3 ((number_of_clocks >= 4) ? "true" : "false"),
                .enable_output_counter_4 ((number_of_clocks >= 5) ? "true" : "false"),
                .enable_output_counter_5 ((number_of_clocks >= 6) ? "true" : "false"),
                .enable_output_counter_6 ((number_of_clocks >= 7) ? "true" : "false"),
                .enable_output_counter_7 ((number_of_clocks >= 8) ? "true" : "false"),
                .enable_output_counter_8 ((number_of_clocks >= 9) ? "true" : "false"),
                .enable_output_counter_9 ((number_of_clocks >= 10) ? "true" : "false"),
                .enable_output_counter_10 ((number_of_clocks >= 11) ? "true" : "false"),
                .enable_output_counter_11 ((number_of_clocks >= 12) ? "true" : "false"),
                .enable_output_counter_12 ((number_of_clocks >= 13) ? "true" : "false"),
                .enable_output_counter_13 ((number_of_clocks >= 14) ? "true" : "false"),
                .enable_output_counter_14 ((number_of_clocks >= 15) ? "true" : "false"),
                .enable_output_counter_15 ((number_of_clocks >= 16) ? "true" : "false"),
                .enable_output_counter_16 ((number_of_clocks >= 17) ? "true" : "false"),
                .enable_output_counter_17 ((number_of_clocks >= 18) ? "true" : "false"),
                .number_of_extclks ((operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? 1 : 0),
                .enable_extclk_output_0 ((operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? "true" : "false"),
                .number_of_counters(number_of_clocks),
                .pll_dsm_out_sel_0((fractional_vco_multiplier == "true") ? pll_dsm_out_sel : "disable"),
                .pll_dsm_dither_0((fractional_vco_multiplier == "true") ? "disable" : "disable"),
                .pll_cp_current_0 (pll_cp_current),
                .pll_fractional_division_0 (pll_fractional_division),
                .pll_fractional_carry_out_0 (pll_fractional_cout),
                .pll_bwctrl_0 (pll_bwctrl),
                .mimic_fbclk_type_0 (mimic_fbclk_type),
                .pll_fbclk_mux_1_0 (pll_fbclk_mux_1),
                .pll_fbclk_mux_2_0 (pll_fbclk_mux_2),
                .pll_m_cnt_in_src_0 (pll_m_cnt_in_src),
                .pll_m_cnt_hi_div_0(m_cnt_hi_div),
                .pll_m_cnt_lo_div_0 (m_cnt_lo_div),
                .pll_m_cnt_bypass_en_0 (m_cnt_bypass_en),
                .pll_m_cnt_odd_div_duty_en_0 (m_cnt_odd_div_duty_en),
                .pll_n_cnt_hi_div_0 (n_cnt_hi_div),
                .pll_n_cnt_lo_div_0 (n_cnt_lo_div),
                .pll_n_cnt_bypass_en_0 (n_cnt_bypass_en),
                .pll_n_cnt_odd_div_duty_en_0 (n_cnt_odd_div_duty_en),
                .output_clock_frequency_0 (output_clock_frequency0),
				.phase_shift_0(phase_shift0),
                .dprio0_cnt_hi_div_0 (c_cnt_hi_div0), 
                .dprio0_cnt_lo_div_0 (c_cnt_lo_div0),
                .dprio0_cnt_bypass_en_0 (c_cnt_bypass_en0),
                .dprio0_cnt_odd_div_even_duty_en_0 (c_cnt_odd_div_duty_en0),
                .c_cnt_prst_0 (c_cnt_prst0),
                .c_cnt_ph_mux_prst_0 (c_cnt_ph_mux_prst0),
                .output_clock_frequency_1 (output_clock_frequency1),
				.phase_shift_1(phase_shift1),
                .dprio0_cnt_hi_div_1 (c_cnt_hi_div1), 
                .dprio0_cnt_lo_div_1 (c_cnt_lo_div1),
                .dprio0_cnt_bypass_en_1 (c_cnt_bypass_en1),
                .dprio0_cnt_odd_div_even_duty_en_1 (c_cnt_odd_div_duty_en1),
                .c_cnt_prst_1 (c_cnt_prst1),
                .c_cnt_ph_mux_prst_1 (c_cnt_ph_mux_prst1),
                .output_clock_frequency_2 (output_clock_frequency2),
				.phase_shift_2(phase_shift2),
                .dprio0_cnt_hi_div_2 (c_cnt_hi_div2), 
                .dprio0_cnt_lo_div_2 (c_cnt_lo_div2),
                .dprio0_cnt_bypass_en_2 (c_cnt_bypass_en2),
                .dprio0_cnt_odd_div_even_duty_en_2 (c_cnt_odd_div_duty_en2),
                .c_cnt_prst_2 (c_cnt_prst2),
                .c_cnt_ph_mux_prst_2 (c_cnt_ph_mux_prst2),
                .output_clock_frequency_3 (output_clock_frequency3),
				.phase_shift_3(phase_shift3),
                .dprio0_cnt_hi_div_3 (c_cnt_hi_div3), 
                .dprio0_cnt_lo_div_3 (c_cnt_lo_div3),
                .dprio0_cnt_bypass_en_3 (c_cnt_bypass_en3),
                .dprio0_cnt_odd_div_even_duty_en_3 (c_cnt_odd_div_duty_en3),
                .c_cnt_prst_3 (c_cnt_prst3),
                .c_cnt_ph_mux_prst_3 (c_cnt_ph_mux_prst3),
                .output_clock_frequency_4 (output_clock_frequency4),
				.phase_shift_4(phase_shift4),
                .dprio0_cnt_hi_div_4 (c_cnt_hi_div4), 
                .dprio0_cnt_lo_div_4 (c_cnt_lo_div4),
                .dprio0_cnt_bypass_en_4 (c_cnt_bypass_en4),
                .dprio0_cnt_odd_div_even_duty_en_4 (c_cnt_odd_div_duty_en4),
                .c_cnt_prst_4 (c_cnt_prst4),
                .c_cnt_ph_mux_prst_4 (c_cnt_ph_mux_prst4),
                .output_clock_frequency_5 (output_clock_frequency5),
				.phase_shift_5(phase_shift5),
                .dprio0_cnt_hi_div_5 (c_cnt_hi_div5), 
                .dprio0_cnt_lo_div_5 (c_cnt_lo_div5),
                .dprio0_cnt_bypass_en_5 (c_cnt_bypass_en5),
                .dprio0_cnt_odd_div_even_duty_en_5 (c_cnt_odd_div_duty_en5),
                .c_cnt_prst_5 (c_cnt_prst5),
                .c_cnt_ph_mux_prst_5 (c_cnt_ph_mux_prst5),
                .output_clock_frequency_6 (output_clock_frequency6),
				.phase_shift_6(phase_shift6),
                .dprio0_cnt_hi_div_6 (c_cnt_hi_div6), 
                .dprio0_cnt_lo_div_6 (c_cnt_lo_div6),
                .dprio0_cnt_bypass_en_6 (c_cnt_bypass_en6),
                .dprio0_cnt_odd_div_even_duty_en_6 (c_cnt_odd_div_duty_en6),
                .c_cnt_prst_6 (c_cnt_prst6),
                .c_cnt_ph_mux_prst_6 (c_cnt_ph_mux_prst6),
                .output_clock_frequency_7 (output_clock_frequency7),
				.phase_shift_7(phase_shift7),
                .dprio0_cnt_hi_div_7 (c_cnt_hi_div7), 
                .dprio0_cnt_lo_div_7 (c_cnt_lo_div7),
                .dprio0_cnt_bypass_en_7 (c_cnt_bypass_en7),
                .dprio0_cnt_odd_div_even_duty_en_7 (c_cnt_odd_div_duty_en7),
                .c_cnt_prst_7 (c_cnt_prst7),
                .c_cnt_ph_mux_prst_7 (c_cnt_ph_mux_prst7),
                .output_clock_frequency_8 (output_clock_frequency8),
				.phase_shift_8(phase_shift8),
                .dprio0_cnt_hi_div_8 (c_cnt_hi_div8), 
                .dprio0_cnt_lo_div_8 (c_cnt_lo_div8),
                .dprio0_cnt_bypass_en_8 (c_cnt_bypass_en8),
                .dprio0_cnt_odd_div_even_duty_en_8 (c_cnt_odd_div_duty_en8),
                .c_cnt_prst_8 (c_cnt_prst8),
                .c_cnt_ph_mux_prst_8 (c_cnt_ph_mux_prst8),
                .output_clock_frequency_9 (output_clock_frequency9),
				.phase_shift_9(phase_shift9),
                .dprio0_cnt_hi_div_9 (c_cnt_hi_div9), 
                .dprio0_cnt_lo_div_9 (c_cnt_lo_div9),
                .dprio0_cnt_bypass_en_9 (c_cnt_bypass_en9),
                .dprio0_cnt_odd_div_even_duty_en_9 (c_cnt_odd_div_duty_en9),
                .c_cnt_prst_9 (c_cnt_prst9),
                .c_cnt_ph_mux_prst_9 (c_cnt_ph_mux_prst9),
                .output_clock_frequency_10 (output_clock_frequency10),
				.phase_shift_10(phase_shift10),
                .dprio0_cnt_hi_div_10 (c_cnt_hi_div10), 
                .dprio0_cnt_lo_div_10 (c_cnt_lo_div10),
                .dprio0_cnt_bypass_en_10 (c_cnt_bypass_en10),
                .dprio0_cnt_odd_div_even_duty_en_10 (c_cnt_odd_div_duty_en10),
                .c_cnt_prst_10 (c_cnt_prst10),
                .c_cnt_ph_mux_prst_10 (c_cnt_ph_mux_prst10),
                .output_clock_frequency_11 (output_clock_frequency11),
				.phase_shift_11(phase_shift11),
                .dprio0_cnt_hi_div_11 (c_cnt_hi_div11), 
                .dprio0_cnt_lo_div_11 (c_cnt_lo_div11),
                .dprio0_cnt_bypass_en_11 (c_cnt_bypass_en11),
                .dprio0_cnt_odd_div_even_duty_en_11 (c_cnt_odd_div_duty_en11),
                .c_cnt_prst_11 (c_cnt_prst11),
                .c_cnt_ph_mux_prst_11 (c_cnt_ph_mux_prst11),
                .output_clock_frequency_12 (output_clock_frequency12),
				.phase_shift_12(phase_shift12),
                .dprio0_cnt_hi_div_12 (c_cnt_hi_div12), 
                .dprio0_cnt_lo_div_12 (c_cnt_lo_div12),
                .dprio0_cnt_bypass_en_12 (c_cnt_bypass_en12),
                .dprio0_cnt_odd_div_even_duty_en_12 (c_cnt_odd_div_duty_en12),
                .c_cnt_prst_12 (c_cnt_prst12),
                .c_cnt_ph_mux_prst_12 (c_cnt_ph_mux_prst12),
                .output_clock_frequency_13 (output_clock_frequency13),
				.phase_shift_13(phase_shift13),
                .dprio0_cnt_hi_div_13 (c_cnt_hi_div13), 
                .dprio0_cnt_lo_div_13 (c_cnt_lo_div13),
                .dprio0_cnt_bypass_en_13 (c_cnt_bypass_en13),
                .dprio0_cnt_odd_div_even_duty_en_13 (c_cnt_odd_div_duty_en13),
                .c_cnt_prst_13 (c_cnt_prst13),
                .c_cnt_ph_mux_prst_13 (c_cnt_ph_mux_prst13),
                .output_clock_frequency_14 (output_clock_frequency14),
				.phase_shift_14(phase_shift14),
                .dprio0_cnt_hi_div_14 (c_cnt_hi_div14), 
                .dprio0_cnt_lo_div_14 (c_cnt_lo_div14),
                .dprio0_cnt_bypass_en_14 (c_cnt_bypass_en14),
                .dprio0_cnt_odd_div_even_duty_en_14 (c_cnt_odd_div_duty_en14),
                .c_cnt_prst_14 (c_cnt_prst14),
                .c_cnt_ph_mux_prst_14 (c_cnt_ph_mux_prst14),
                .output_clock_frequency_15 (output_clock_frequency15),
				.phase_shift_15(phase_shift15),
                .dprio0_cnt_hi_div_15 (c_cnt_hi_div15), 
                .dprio0_cnt_lo_div_15 (c_cnt_lo_div15),
                .dprio0_cnt_bypass_en_15 (c_cnt_bypass_en15),
                .dprio0_cnt_odd_div_even_duty_en_15 (c_cnt_odd_div_duty_en15),
                .c_cnt_prst_15 (c_cnt_prst15),
                .c_cnt_ph_mux_prst_15 (c_cnt_ph_mux_prst15),
                .output_clock_frequency_16 (output_clock_frequency16),
				.phase_shift_16(phase_shift16),
                .dprio0_cnt_hi_div_16 (c_cnt_hi_div16), 
                .dprio0_cnt_lo_div_16 (c_cnt_lo_div16),
                .dprio0_cnt_bypass_en_16 (c_cnt_bypass_en16),
                .dprio0_cnt_odd_div_even_duty_en_16 (c_cnt_odd_div_duty_en16),
                .c_cnt_prst_16 (c_cnt_prst16),
                .c_cnt_ph_mux_prst_16 (c_cnt_ph_mux_prst16),
                .output_clock_frequency_17 (output_clock_frequency17),
				.phase_shift_17(phase_shift17),
                .dprio0_cnt_hi_div_17 (c_cnt_hi_div17), 
                .dprio0_cnt_lo_div_17 (c_cnt_lo_div17),
                .dprio0_cnt_bypass_en_17 (c_cnt_bypass_en17),
                .dprio0_cnt_odd_div_even_duty_en_17 (c_cnt_odd_div_duty_en17),
                .c_cnt_prst_17 (c_cnt_prst17),
                .c_cnt_ph_mux_prst_17 (c_cnt_ph_mux_prst17),
				//output counter cascading params
                .c_cnt_in_src_0 (c_cnt_in_src0),
                .c_cnt_in_src_1 (c_cnt_in_src1),
                .c_cnt_in_src_2 (c_cnt_in_src2),
                .c_cnt_in_src_3 (c_cnt_in_src3),
                .c_cnt_in_src_4 (c_cnt_in_src4),
                .c_cnt_in_src_5 (c_cnt_in_src5),
                .c_cnt_in_src_6 (c_cnt_in_src6),
                .c_cnt_in_src_7 (c_cnt_in_src7),
                .c_cnt_in_src_8 (c_cnt_in_src8),
                .c_cnt_in_src_9 (c_cnt_in_src9),
                .c_cnt_in_src_10 (c_cnt_in_src10),
                .c_cnt_in_src_11 (c_cnt_in_src11),
                .c_cnt_in_src_12 (c_cnt_in_src12),
                .c_cnt_in_src_13 (c_cnt_in_src13),
                .c_cnt_in_src_14 (c_cnt_in_src14),
                .c_cnt_in_src_15 (c_cnt_in_src15),
                .c_cnt_in_src_16 (c_cnt_in_src16),
                .c_cnt_in_src_17 (c_cnt_in_src17),
                //refclk select params
                .pll_auto_clk_sw_en_0 (pll_auto_clk_sw_en),
                .pll_clk_loss_sw_en_0 (pll_clk_loss_sw_en),
                .pll_clk_sw_dly_0    (pll_clk_sw_dly),
                .pll_clkin_0_src_0   (pll_clkin_0_src),
                .pll_clkin_1_src_0   (pll_clkin_1_src),
                .pll_manu_clk_sw_en_0  (pll_manu_clk_sw_en)
			)
             arriavgz_pll (
                // stratixv_pll_dpa_output pins
                .phout_0(phout_wire),
                .phout_1(),
                
                // stratixv_pll_refclk_select pins
                .adjpllin(adjpllin),    
                .cclk(cclk),
                .coreclkin(),
                .extswitch(extswitch),
                .iqtxrxclkin(),
                .plliqclkin(),
                .rxiqclkin(),
                .clkin({2'b0,refclk1, refclk}),
                .refiqclk_0(),
                .refiqclk_1(),
                .clk0bad(clkbad_wire[0]),
                .clk1bad(clkbad_wire[1]),
                .pllclksel(activeclk_wire),

                // stratixv_pll_reconfig pins
                .atpgmode(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_atpgmode : reconfig_to_pll[38]) : 1'b0),
                .clk(pll_subtype != "General" ? ((pll_subtype == "DPS") ? scanclk : reconfig_to_pll[0]) : 1'b0),
                .fpllcsrtest(reconfig_to_pll[38]),
                .iocsrclkin(),
                .iocsrdatain(),
                .iocsren(),
                .iocsrrstn(),
                .mdiodis(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_mdio_dis: reconfig_to_pll[29]) : 1'b1),
                .phaseen(final_phase_en),
                .read(reconfig_to_pll[3]),
                .rstn(pll_subtype != "General" ? ((pll_subtype == "DPS") ? ~rst : reconfig_to_pll[1]): 1'b1),
                .scanen(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_scanen : reconfig_to_pll[37]) : 1'b0),
                .sershiftload(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_ser_shift_load : reconfig_to_pll[28]) : 1'b1),
                .shiftdonei(),
                .updn(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? updn:reconfig_to_pll[31]) : 1'b0),
                .write(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_write : reconfig_to_pll[2]) :1'b0),
                .addr_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_address : reconfig_to_pll[9:4]) :6'b000000),
                .addr_1(),
                .byteen_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_byteen : reconfig_to_pll[27:26]) :2'b00),
                .byteen_1(),
                .cntsel_0(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? cntsel_int:reconfig_to_pll[36:32]) : 5'b00000),
                .cntsel_1(),
                .din_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_writedata : reconfig_to_pll[25:10]) :16'h0000),
                .din_1(),
                .blockselect(),
                .iocsrdataout(),
                .iocsrenbuf(),
                .iocsrrstnbuf(),
                .phasedone(reconfig_from_pll_wire[17]),
                .dout_0(reconfig_from_pll_wire[15:0]),
                .dout_1(),
                .dprioout_0(),
                .dprioout_1(),
                
                // stratixv_fractional_pll pins
                .fbclkfpll(),
                .lvdfbin((operation_mode == "lvds") ? lvds_fbclk : 1'b0),
                .nresync(~rst),
                .pfden(1'b1),
                .shiften_fpll(),
                .zdb((operation_mode == "external feedback") ? fb_clkin : (operation_mode == "zero delay buffer") ? fb_out_clk : 1'b0),
                .fblvdsout(lvds_fbclk),
                .lock(reconfig_from_pll_wire[16]),
                .mcntout(),
                .plniotribuf(),

                // stratixv_pll_extclk_output pins
                .clken(),
                .extclk(fboutclk_wire[0]),

                // stratixv_pll_dll_output pins
                .dll_clkin(),
                .clkout(),

                // stratixv_pll_lvds_output pins
                .loaden(),
                .lvdsclk(),

                // stratixv_pll_output_counter pins
                .divclk(divclk_wire),
				.cascade_out(cascade_out_wire)
                );
                
                assign locked_wire[0] = reconfig_from_pll_wire[16]; 
                assign outclk_wire = divclk_wire;
            end
            else if (pll_type == "Cyclone V") 
            begin    

            //cnt select luts (5)
            pll_dps_lcell_comb lcell_cntsel_int_0 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[0]));
            defparam lcell_cntsel_int_0.lut_mask = 64'hAAAAAAAAAAAAAAAA;
            defparam lcell_cntsel_int_0.dont_touch = "on";
            defparam lcell_cntsel_int_0.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_1 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[1]));
            defparam lcell_cntsel_int_1.lut_mask = 64'hCCCCCCCCCCCCCCCC;
            defparam lcell_cntsel_int_1.dont_touch = "on";
            defparam lcell_cntsel_int_1.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_2 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[2]));
            defparam lcell_cntsel_int_2.lut_mask = 64'hF0F0F0F0F0F0F0F0;
            defparam lcell_cntsel_int_2.dont_touch = "on";
            defparam lcell_cntsel_int_2.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_3 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[3]));
            defparam lcell_cntsel_int_3.lut_mask = 64'hFF00FF00FF00FF00;
            defparam lcell_cntsel_int_3.dont_touch = "on";
            defparam lcell_cntsel_int_3.family = pll_type;
            pll_dps_lcell_comb lcell_cntsel_int_4 (
                .dataa(cntsel_temp[0]),
                .datab(cntsel_temp[1]),
                .datac(cntsel_temp[2]),
                .datad(cntsel_temp[3]),
                .datae(cntsel_temp[4]),
                .dataf(gnd),
                .combout (cntsel_int[4]));
            defparam lcell_cntsel_int_4.lut_mask = 64'hFFFF0000FFFF0000;
            defparam lcell_cntsel_int_4.dont_touch = "on";
            defparam lcell_cntsel_int_4.family = pll_type;
   
            altera_cyclonev_pll #(
                .number_of_fplls(1),
                .pll_vco_div_0(pll_vco_div),
                .reference_clock_frequency_0 (reference_clock_frequency),
                .pll_output_clock_frequency_0 (pll_output_clk_frequency),
                .dpa_output_clock_frequency_0 (pll_output_clk_frequency),
                .enable_output_counter_0 ((number_of_clocks >= 1) ? "true" : "false"),
                .enable_output_counter_1 ((number_of_clocks >= 2) ? "true" : "false"),
                .enable_output_counter_2 ((number_of_clocks >= 3) ? "true" : "false"),
                .enable_output_counter_3 ((number_of_clocks >= 4) ? "true" : "false"),
                .enable_output_counter_4 ((number_of_clocks >= 5) ? "true" : "false"),
                .enable_output_counter_5 ((number_of_clocks >= 6) ? "true" : "false"),
                .enable_output_counter_6 ((number_of_clocks >= 7) ? "true" : "false"),
                .enable_output_counter_7 ((number_of_clocks >= 8) ? "true" : "false"),
                .enable_output_counter_8 ((number_of_clocks >= 9) ? "true" : "false"),
                .number_of_extclks ((operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? 1 : 0),
                .enable_extclk_output_0 ((operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? "true" : "false"),
                .number_of_counters(number_of_clocks),
                .pll_dsm_out_sel_0((fractional_vco_multiplier == "true") ? pll_dsm_out_sel : "disable"),
                .pll_dsm_dither_0((fractional_vco_multiplier == "true") ? "disable" : "disable"),
                .pll_cp_current_0 (pll_cp_current),
                .pll_fractional_division_0 (pll_fractional_division),
                .pll_fractional_carry_out_0 (pll_fractional_cout),
                .pll_bwctrl_0 (pll_bwctrl),
                .mimic_fbclk_type_0 (mimic_fbclk_type),
                .pll_fbclk_mux_1_0 (pll_fbclk_mux_1),
                .pll_fbclk_mux_2_0 (pll_fbclk_mux_2),
                .pll_m_cnt_in_src_0 (pll_m_cnt_in_src),
                .pll_m_cnt_hi_div_0(m_cnt_hi_div),
                .pll_m_cnt_lo_div_0 (m_cnt_lo_div),
                .pll_m_cnt_bypass_en_0 (m_cnt_bypass_en),
                .pll_m_cnt_odd_div_duty_en_0 (m_cnt_odd_div_duty_en),
                .pll_n_cnt_hi_div_0 (n_cnt_hi_div),
                .pll_n_cnt_lo_div_0 (n_cnt_lo_div),
                .pll_n_cnt_bypass_en_0 (n_cnt_bypass_en),
                .pll_n_cnt_odd_div_duty_en_0 (n_cnt_odd_div_duty_en),
                .output_clock_frequency_0 (output_clock_frequency0),
                .phase_shift_0(phase_shift0),
                .dprio0_cnt_hi_div_0 (c_cnt_hi_div0), 
                .dprio0_cnt_lo_div_0 (c_cnt_lo_div0),
                .dprio0_cnt_bypass_en_0 (c_cnt_bypass_en0),
                .dprio0_cnt_odd_div_even_duty_en_0 (c_cnt_odd_div_duty_en0),
                .c_cnt_prst_0 (c_cnt_prst0),
                .c_cnt_ph_mux_prst_0 (c_cnt_ph_mux_prst0),
                .output_clock_frequency_1 (output_clock_frequency1),
                .phase_shift_1(phase_shift1),
                .dprio0_cnt_hi_div_1 (c_cnt_hi_div1), 
                .dprio0_cnt_lo_div_1 (c_cnt_lo_div1),
                .dprio0_cnt_bypass_en_1 (c_cnt_bypass_en1),
                .dprio0_cnt_odd_div_even_duty_en_1 (c_cnt_odd_div_duty_en1),
                .c_cnt_prst_1 (c_cnt_prst1),
                .c_cnt_ph_mux_prst_1 (c_cnt_ph_mux_prst1),
                .output_clock_frequency_2 (output_clock_frequency2),
                .phase_shift_2(phase_shift2),
                .dprio0_cnt_hi_div_2 (c_cnt_hi_div2), 
                .dprio0_cnt_lo_div_2 (c_cnt_lo_div2),
                .dprio0_cnt_bypass_en_2 (c_cnt_bypass_en2),
                .dprio0_cnt_odd_div_even_duty_en_2 (c_cnt_odd_div_duty_en2),
                .c_cnt_prst_2 (c_cnt_prst2),
                .c_cnt_ph_mux_prst_2 (c_cnt_ph_mux_prst2),
                .output_clock_frequency_3 (output_clock_frequency3),
                .phase_shift_3(phase_shift3),
                .dprio0_cnt_hi_div_3 (c_cnt_hi_div3), 
                .dprio0_cnt_lo_div_3 (c_cnt_lo_div3),
                .dprio0_cnt_bypass_en_3 (c_cnt_bypass_en3),
                .dprio0_cnt_odd_div_even_duty_en_3 (c_cnt_odd_div_duty_en3),
                .c_cnt_prst_3 (c_cnt_prst3),
                .c_cnt_ph_mux_prst_3 (c_cnt_ph_mux_prst3),
                .output_clock_frequency_4 (output_clock_frequency4),
                .phase_shift_4(phase_shift4),
                .dprio0_cnt_hi_div_4 (c_cnt_hi_div4), 
                .dprio0_cnt_lo_div_4 (c_cnt_lo_div4),
                .dprio0_cnt_bypass_en_4 (c_cnt_bypass_en4),
                .dprio0_cnt_odd_div_even_duty_en_4 (c_cnt_odd_div_duty_en4),
                .c_cnt_prst_4 (c_cnt_prst4),
                .c_cnt_ph_mux_prst_4 (c_cnt_ph_mux_prst4),
                .output_clock_frequency_5 (output_clock_frequency5),
                .phase_shift_5(phase_shift5),
                .dprio0_cnt_hi_div_5 (c_cnt_hi_div5), 
                .dprio0_cnt_lo_div_5 (c_cnt_lo_div5),
                .dprio0_cnt_bypass_en_5 (c_cnt_bypass_en5),
                .dprio0_cnt_odd_div_even_duty_en_5 (c_cnt_odd_div_duty_en5),
                .c_cnt_prst_5 (c_cnt_prst5),
                .c_cnt_ph_mux_prst_5 (c_cnt_ph_mux_prst5),
                .output_clock_frequency_6 (output_clock_frequency6),
                .phase_shift_6(phase_shift6),
                .dprio0_cnt_hi_div_6 (c_cnt_hi_div6), 
                .dprio0_cnt_lo_div_6 (c_cnt_lo_div6),
                .dprio0_cnt_bypass_en_6 (c_cnt_bypass_en6),
                .dprio0_cnt_odd_div_even_duty_en_6 (c_cnt_odd_div_duty_en6),
                .c_cnt_prst_6 (c_cnt_prst6),
                .c_cnt_ph_mux_prst_6 (c_cnt_ph_mux_prst6),
                .output_clock_frequency_7 (output_clock_frequency7),
                .phase_shift_7(phase_shift7),
                .dprio0_cnt_hi_div_7 (c_cnt_hi_div7), 
                .dprio0_cnt_lo_div_7 (c_cnt_lo_div7),
                .dprio0_cnt_bypass_en_7 (c_cnt_bypass_en7),
                .dprio0_cnt_odd_div_even_duty_en_7 (c_cnt_odd_div_duty_en7),
                .c_cnt_prst_7 (c_cnt_prst7),
                .c_cnt_ph_mux_prst_7 (c_cnt_ph_mux_prst7),
                .output_clock_frequency_8 (output_clock_frequency8),
                .phase_shift_8(phase_shift8),
                .dprio0_cnt_hi_div_8 (c_cnt_hi_div8), 
                .dprio0_cnt_lo_div_8 (c_cnt_lo_div8),
                .dprio0_cnt_bypass_en_8 (c_cnt_bypass_en8),
                .dprio0_cnt_odd_div_even_duty_en_8 (c_cnt_odd_div_duty_en8),
                .c_cnt_prst_8 (c_cnt_prst8),
                .c_cnt_ph_mux_prst_8 (c_cnt_ph_mux_prst8),
				//output counter cascading params
                .c_cnt_in_src_0 (c_cnt_in_src0),
                .c_cnt_in_src_1 (c_cnt_in_src1),
                .c_cnt_in_src_2 (c_cnt_in_src2),
                .c_cnt_in_src_3 (c_cnt_in_src3),
                .c_cnt_in_src_4 (c_cnt_in_src4),
                .c_cnt_in_src_5 (c_cnt_in_src5),
                .c_cnt_in_src_6 (c_cnt_in_src6),
                .c_cnt_in_src_7 (c_cnt_in_src7),
                .c_cnt_in_src_8 (c_cnt_in_src8),
                //refclk select params
                .pll_auto_clk_sw_en_0 (pll_auto_clk_sw_en),
                .pll_clk_loss_sw_en_0 (pll_clk_loss_sw_en),
                .pll_clk_sw_dly_0    (pll_clk_sw_dly),
                .pll_clkin_0_src_0   (pll_clkin_0_src),
                .pll_clkin_1_src_0   (pll_clkin_1_src),
                .pll_manu_clk_sw_en_0  (pll_manu_clk_sw_en)
        )

             cyclonev_pll (
                // cyclonev_pll_dpa_output pins
                .phout_0(phout_wire),
                
                // cyclonev_pll_refclk_select pins
                .adjpllin(adjpllin),    
                .cclk(cclk),
                .coreclkin(),
                .extswitch(extswitch),
                .iqtxrxclkin(),
                .plliqclkin(),
                .rxiqclkin(),
                .clkin({2'b0,refclk1, refclk}),
                .refiqclk_0(),
                .refiqclk_1(),
                .clk0bad(clkbad_wire[0]),
                .clk1bad(clkbad_wire[1]),
                .pllclksel(activeclk_wire),

                // cyclonev_pll_reconfig pins
                .atpgmode(),
                .clk(pll_subtype != "General" ? ((pll_subtype == "DPS") ? scanclk : reconfig_to_pll[0]) : 1'b0),
                .fpllcsrtest(),
                .iocsrclkin(),
                .iocsrdatain(),
                .iocsren(),
                .iocsrrstn(),
                .mdiodis(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_mdio_dis: reconfig_to_pll[29]) : 1'b1),
                .phaseen(final_phase_en),
                .read(reconfig_to_pll[3]),
                .rstn(pll_subtype != "General" ? ((pll_subtype == "DPS") ? ~rst : reconfig_to_pll[1]): 1'b1),
                .scanen(),
                .sershiftload(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_ser_shift_load : reconfig_to_pll[28]) : 1'b1),
                .shiftdonei(),
                .updn(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? updn:reconfig_to_pll[31]) : 1'b0),
                .write(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_write : reconfig_to_pll[2]) :1'b0),
                .addr_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_address : reconfig_to_pll[9:4]) :6'b000000),
                .byteen_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_byteen : reconfig_to_pll[27:26]) :2'b00),
                .cntsel_0(pll_subtype != "General" ? ((pll_subtype == "ReconfDPS") || (pll_subtype == "DPS") ? cntsel_int:reconfig_to_pll[36:32]) : 5'b00000),
                .din_0(pll_subtype != "General" ? ((pll_subtype == "DPS") ? dps_writedata : reconfig_to_pll[25:10]) :16'h0000),
                .blockselect(),
                .iocsrdataout(),
                .iocsrenbuf(),
                .iocsrrstnbuf(),
                .phasedone(reconfig_from_pll_wire[17]),
                .dout_0(reconfig_from_pll_wire[15:0]),
                .dprioout_0(),
                
                // cyclonev_fractional_pll pins
                .fbclkfpll(),
                .lvdfbin((operation_mode == "lvds") ? lvds_fbclk : 1'b0),
                .nresync(~rst),
                .pfden(1'b1),
                .shiften_fpll(),
                .fblvdsout(lvds_fbclk),
                .zdb((operation_mode == "external feedback") ? fb_clkin : (operation_mode == "zero delay buffer") ? fb_out_clk : 1'b0),
                .lock(reconfig_from_pll_wire[16]),
                .mcntout(),
                .plniotribuf(),

                // cyclonev_pll_extclk_output pins
                .clken(),
                .extclk(fboutclk_wire[0]),

                // cyclonev_pll_dll_output pins
                .dll_clkin(),
                .clkout(),

                // cyclonev_pll_lvds_output pins
                .loaden(),
                .lvdsclk(),

                // cyclonev_pll_output_counter pins
                .divclk(divclk_wire),
				.cascade_out(cascade_out_wire)
                );
                
                assign locked_wire[0] = reconfig_from_pll_wire[16]; 
                assign outclk_wire = divclk_wire;
            end  
			else if (pll_type == "Stratix VI" || pll_type == "Arria VI") 
            begin    
            twentynm_iopll_ip #(
                .reference_clock_frequency (reference_clock_frequency),
                .vco_frequency (pll_output_clk_frequency),
				.output_clock_frequency_0(output_clock_frequency0),
				.output_clock_frequency_1(output_clock_frequency1),
				.output_clock_frequency_2(output_clock_frequency2),
				.output_clock_frequency_3(output_clock_frequency3),
				.output_clock_frequency_4(output_clock_frequency4),
				.output_clock_frequency_5(output_clock_frequency5),
				.output_clock_frequency_6(output_clock_frequency6),
				.output_clock_frequency_7(output_clock_frequency7),
				.output_clock_frequency_8(output_clock_frequency8),
				.phase_shift_0(phase_shift0),
				.phase_shift_1(phase_shift1),
				.phase_shift_2(phase_shift2),
				.phase_shift_3(phase_shift3),
				.phase_shift_4(phase_shift4),
				.phase_shift_5(phase_shift5),
				.phase_shift_6(phase_shift6),
				.phase_shift_7(phase_shift7),
				.phase_shift_8(phase_shift8),
				.pll_auto_clk_sw_en (pll_auto_clk_sw_en),
				.pll_c0_out_en ((output_clock_frequency0 != "0 ps") ? "true" : "false"),
				.pll_c1_out_en ((output_clock_frequency1 != "0 ps") ? "true" : "false"),
				.pll_c2_out_en ((output_clock_frequency2 != "0 ps") ? "true" : "false"),
				.pll_c3_out_en ((output_clock_frequency3 != "0 ps") ? "true" : "false"),
				.pll_c4_out_en ((output_clock_frequency4 != "0 ps") ? "true" : "false"),
				.pll_c5_out_en ((output_clock_frequency5 != "0 ps") ? "true" : "false"),
				.pll_c6_out_en ((output_clock_frequency6 != "0 ps") ? "true" : "false"),
				.pll_c7_out_en ((output_clock_frequency7 != "0 ps") ? "true" : "false"),
				.pll_c8_out_en ((output_clock_frequency8 != "0 ps") ? "true" : "false"),
				.pll_c_counter_0_bypass_en (c_cnt_bypass_en0),
				.pll_c_counter_0_even_duty_en (c_cnt_odd_div_duty_en0),
				.pll_c_counter_0_high (c_cnt_hi_div0),
				.pll_c_counter_0_low (c_cnt_lo_div0),
				.pll_c_counter_0_ph_mux_prst (c_cnt_ph_mux_prst0),
				.pll_c_counter_0_prst (c_cnt_prst0),				
				.pll_c_counter_1_bypass_en (c_cnt_bypass_en1),
				.pll_c_counter_1_even_duty_en (c_cnt_odd_div_duty_en1),
				.pll_c_counter_1_high (c_cnt_hi_div1),
				.pll_c_counter_1_low (c_cnt_lo_div1),
				.pll_c_counter_1_ph_mux_prst (c_cnt_ph_mux_prst1),
				.pll_c_counter_1_prst (c_cnt_prst1),
				.pll_c_counter_2_bypass_en (c_cnt_bypass_en2),
				.pll_c_counter_2_even_duty_en (c_cnt_odd_div_duty_en2),
				.pll_c_counter_2_high (c_cnt_hi_div2),
				.pll_c_counter_2_low (c_cnt_lo_div2),
				.pll_c_counter_2_ph_mux_prst (c_cnt_ph_mux_prst2),
				.pll_c_counter_2_prst (c_cnt_prst2),
				.pll_c_counter_3_bypass_en (c_cnt_bypass_en3),
				.pll_c_counter_3_even_duty_en (c_cnt_odd_div_duty_en3),
				.pll_c_counter_3_high (c_cnt_hi_div3),
				.pll_c_counter_3_low (c_cnt_lo_div3),
				.pll_c_counter_3_ph_mux_prst (c_cnt_ph_mux_prst3),
				.pll_c_counter_3_prst (c_cnt_prst3),
				.pll_c_counter_4_bypass_en (c_cnt_bypass_en4),
				.pll_c_counter_4_even_duty_en (c_cnt_odd_div_duty_en4),
				.pll_c_counter_4_high (c_cnt_hi_div4),
				.pll_c_counter_4_low (c_cnt_lo_div4),
				.pll_c_counter_4_ph_mux_prst (c_cnt_ph_mux_prst4),
				.pll_c_counter_4_prst (c_cnt_prst4),
				.pll_c_counter_5_bypass_en (c_cnt_bypass_en5),
				.pll_c_counter_5_even_duty_en (c_cnt_odd_div_duty_en5),
				.pll_c_counter_5_high (c_cnt_hi_div5),
				.pll_c_counter_5_low (c_cnt_lo_div5),
				.pll_c_counter_5_ph_mux_prst (c_cnt_ph_mux_prst5),
				.pll_c_counter_5_prst (c_cnt_prst5),
				.pll_c_counter_6_bypass_en (c_cnt_bypass_en6),
				.pll_c_counter_6_even_duty_en (c_cnt_odd_div_duty_en6),
				.pll_c_counter_6_high (c_cnt_hi_div6),
				.pll_c_counter_6_low (c_cnt_lo_div6),
				.pll_c_counter_6_ph_mux_prst (c_cnt_ph_mux_prst6),
				.pll_c_counter_6_prst (c_cnt_prst6),
				.pll_c_counter_7_bypass_en (c_cnt_bypass_en7),
				.pll_c_counter_7_even_duty_en (c_cnt_odd_div_duty_en7),
				.pll_c_counter_7_high (c_cnt_hi_div7),
				.pll_c_counter_7_low (c_cnt_lo_div7),
				.pll_c_counter_7_ph_mux_prst (c_cnt_ph_mux_prst7),
				.pll_c_counter_7_prst (c_cnt_prst7),
				.pll_c_counter_8_bypass_en (c_cnt_bypass_en8),
				.pll_c_counter_8_even_duty_en (c_cnt_odd_div_duty_en8),
				.pll_c_counter_8_high (c_cnt_hi_div8),
				.pll_c_counter_8_low (c_cnt_lo_div8),
				.pll_c_counter_8_ph_mux_prst (c_cnt_ph_mux_prst8),
				.pll_c_counter_8_prst (c_cnt_prst8),
                .pll_clk_sw_dly (pll_clk_sw_dly),
                .pll_enable ("true"),
				.pll_m_counter_bypass_en (m_cnt_bypass_en),
				.pll_m_counter_even_duty_en (m_cnt_odd_div_duty_en),
				.pll_m_counter_high(m_cnt_hi_div),
				.pll_m_counter_low(m_cnt_lo_div),
				.pll_mode("true"),
				.pll_n_counter_bypass_en(n_cnt_bypass_en),
				.pll_n_counter_high(n_cnt_hi_div),
				.pll_n_counter_low(n_cnt_lo_div),
                .pll_n_counter_odd_div_duty_en (n_cnt_odd_div_duty_en),
				.pll_manu_clk_sw_en (pll_manu_clk_sw_en),
				.pll_vco_ph0_en ("true"),
				.pll_vco_ph1_en ("true"),
				.pll_vco_ph2_en ("true"),
				.pll_vco_ph3_en ("true"),
				.pll_vco_ph4_en ("true"),
				.pll_vco_ph5_en ("true"),
				.pll_vco_ph6_en ("true"),
				.pll_vco_ph7_en ("true")
			) twentynm_pll (
				.clken(),
				.cnt_sel(cntsel),
				.refclk({2'b0,refclk1, refclk}),
				.core_refclk(),
				.csr_clk(),
				.csr_en(),
				.csr_in(),
				.csr_test_mode(),
				.dprio_clk(),
				.dprio_rst_n(),
				.dps_rst_n(~rst),
				.extswitch(extswitch),
				.fbclk_in(),
				.fblvds_in((operation_mode == "lvds") ? lvds_fbclk : 1'b0),
				.mdio_dis((operation_mode == "lvds") ? dps_mdio_dis : 1'b0),
				.rst_n(~rst),
				.num_phase_shifts(),
				.pfden(1'b1),
				.phase_en(final_phase_en),
				.pma_csr_test_dis(),
				.read(),
				.pll_cascade_in(),
				.dprio_address(),
				.scan_mode_n(),
				.scan_shift_n(),
				.up_dn(),
				.write(),
				.writedata(),
				.zdb_in((operation_mode == "external feedback") ? fb_clkin : (operation_mode == "zero delay buffer") ? fb_out_clk : 1'b0),
			
				.block_select(),
				.clk0_bad(clkbad_wire[0]),
                .clk1_bad(clkbad_wire[1]),
				.clksel(activeclk_wire),
				.csr_out(),
				.extclk_output(),
				.extclk_dft(),
				.fblvds_out(lvds_fbclk),
				.loaden(),
				.lock(locked_wire[0]),
				.lvds_clk(),
				.phase_done(),
				.pll_cascade_out(cascade_out),
				.outclk(divclk_wire),
				.dll_output(),
				.fbclk_out(),
				.readdata(),
				.vcoph()
            );
                
            assign outclk_wire = divclk_wire;
        end        
    end
    `endif
endgenerate

assign reconfig_from_pll = (pll_type == "General") ? 64'b0 : reconfig_from_pll_wire;
generate 
    if (pll_subtype == "DPS" || pll_subtype == "ReconfDPS")
        assign phase_done = reconfig_from_pll_wire[17];
    else 
        assign phase_done = 1'b0;
endgenerate
generate 
    if (pll_type == "General")
    begin
        assign clkbad = 0;
        assign activeclk = 0;
	assign phout = 0;
	assign cascade_out = 0;

    end
    else 
    begin
        assign clkbad = clkbad_wire;
        assign activeclk = activeclk_wire;
	assign phout = phout_wire;
	assign cascade_out = cascade_out_wire;
    end
endgenerate

assign fboutclk = (operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? fb_out_clk : fboutclk_wire[0]; 

assign outclk = outclk_wire;
assign zdbfbclk = (operation_mode == "zero delay buffer") ? zdbfbclk : 1'b0;

// this is not correct for the old model
assign locked = locked_wire[0];

// synthesis translate off
generate
genvar j;
    if ( (pll_type == "General") && (use_old_model ==  0 || use_old_model == -1) && pll_frequency_parameter > 0 )
    begin : new_model
        generic_pll #(
                .reference_clock_frequency(reference_clock_frequency),
				.fractional_vco_multiplier(fractional_vco_multiplier),
                .sim_additional_refclk_cycles_to_lock(sim_additional_refclk_cycles_to_lock),
				.use_khz(using_khz),
                .output_clock_frequency( convert_to_mhz_string(pll_frequency_parameter,using_khz) ), 
                .duty_cycle(50), 
                .phase_shift("0 ps") )
                gpll (
                     .refclk(refclk),
                     .fbclk((operation_mode == "external feedback") ? fb_clkin : (operation_mode == "zero delay buffer") ? fb_out_clk : fboutclk_wire[0]),
                     .rst(rst),
                     .fboutclk(fboutclk_wire[0]),
                     .outclk(pll_clock),
                     .locked(locked_wire[0])
                 );
        for (j = 0; j < number_of_clocks; j = j + 1)
        begin : output_counters
            always @(pll_clock or negedge locked_wire[0])
            begin
                if ( locked_wire[0] )
                begin
                    if ( count_up_to_C[j] == 0 )
                    begin
                        if (duty_cycle_parameter[j] != 50)
                        begin
                            // allign with the posedge
                            if ( pll_clock == 1'b1)
                            begin
                                outclk_reg[j] <= 1'b1;
                                outclk_reg[j] <= #(duty_cycle_hi[j]) 1'b0;
                                
                            end
                        end
                        else
                        begin
                            outclk_reg[j] <= ~outclk_reg[j];
                        end
                    end
                    if ( count_up_to_C[j] + 1 ==  counter_C[j] )
                        count_up_to_C[j] <= 0;
                    else
                        count_up_to_C[j] <= count_up_to_C[j] + 1;
                end
                else
                begin
                    count_up_to_C[j] <= 0;
                    outclk_reg[j] <= 1'b0;
                end
            end

            always @(outclk_reg[j])
            begin
                // The LHS is important to make the sim work.
                // It is like a transport line and this is the only way it can
                // work for phase > period.
                // However, it may make the simulation slower.
                outclk_reg_phase[j] <= #(phase_shift_value[j]) outclk_reg[j];
            end

            // guard by the phase
            // if no phase, change to 0 delta delay.
            assign outclk_wire[j] = (phase_shift_value[j] == 0) ? outclk_reg[j] :
                                    // do not propage an x value after lock
                                    ( outclk_reg_phase[j] === 1'bX && locked_wire[0] === 1'b1) ? 1'b0 :
                                    // phase shifted value
                                    outclk_reg_phase[j];
        
        end
        
    end
endgenerate 


// synthesis translate on


generate
    if (operation_mode == "external feedback")
    begin: fb_ibuf
    alt_inbuf #(.enable_bus_hold("NONE")) fb_ibuf (
                          .i(fbclk),
                          .o(fb_clkin)
                      );
    end
endgenerate

generate 
    if (operation_mode == "external feedback")
    begin: fb_obuf
    alt_outbuf #(.enable_bus_hold("NONE"))  fb_obuf (
                           .i(fboutclk_wire[0]),
                           .o(fb_out_clk)
                       );
    end
endgenerate

generate
    if (operation_mode == "zero delay buffer")
    begin: fb_iobuf
    alt_iobuf #(.enable_bus_hold("NONE"))  fb_iobuf (
                           .i(fboutclk_wire[0]),
                           .oe(1'b1),
                           .io(zdbfbclk),
                           .o(fb_out_clk)
                       );
    end
endgenerate

endmodule
module dps_extra_kick (
    input   wire        clk,
    input   wire        reset,
    input   wire        phase_done,
    input   wire        usr_phase_en,
    //output
    output  wire        phase_en);

    reg [3:0]       dps_current_state;
    reg [3:0]       dps_next_state;
    reg             int_phase_en;
    localparam PHASE_DONE_LOW_0 = 4'd0, PHASE_DONE_LOW_1 = 4'd1, PHASE_DONE_LOW_2 = 4'd2, PHASE_DONE_LOW_3 = 4'd3, PHASE_DONE_LOW_4 = 4'd4, PHASE_DONE_HIGH = 4'd5; 
    localparam PHASE_EN_WAIT_COUNTER = 5'd0;

    //fsm
    //always block controlling the state regs
    always @(posedge clk)
    begin
        if (reset)
        begin
            dps_current_state <= PHASE_DONE_HIGH;
        end
        else
        begin
            dps_current_state <= dps_next_state;
        end
    end
 
    always @(*)
    begin
        int_phase_en = 0;
        dps_next_state = PHASE_DONE_HIGH;
        case (dps_current_state)
            PHASE_DONE_HIGH:
            begin
                if (phase_done == 1'b1)
                    dps_next_state = PHASE_DONE_HIGH;
                else 
                    dps_next_state = PHASE_DONE_LOW_0;
            end
            PHASE_DONE_LOW_0:
            begin
                if (phase_done == 1'b1)
                    dps_next_state = PHASE_DONE_HIGH;
                else 
                    dps_next_state = PHASE_DONE_LOW_1;
            end
            PHASE_DONE_LOW_1:
            begin
                if (phase_done == 1'b1)
                    dps_next_state = PHASE_DONE_HIGH;
                else 
                    dps_next_state = PHASE_DONE_LOW_2;
            end
            PHASE_DONE_LOW_2:
            begin
                if (phase_done == 1'b1)
                    dps_next_state = PHASE_DONE_HIGH;
                else 
                    dps_next_state = PHASE_DONE_LOW_3;
            end
            PHASE_DONE_LOW_3:
            begin
                if (phase_done == 1'b1)
                    dps_next_state = PHASE_DONE_HIGH;
                else 
                    dps_next_state = PHASE_DONE_LOW_4;
            end
            PHASE_DONE_LOW_4:
            begin
                if (phase_done == 1'b0)
                    int_phase_en = 1'b1;
                dps_next_state = PHASE_DONE_HIGH;
            end
            default: dps_next_state = 4'bxxxx;
        endcase
    end
    assign phase_en = (usr_phase_en === 1'bz) ? 1'bz : (usr_phase_en || int_phase_en);
endmodule
module dprio_init (
    input               clk,
    input               reset_n,

    output      [ 5:0]  dprio_address,
    output      [ 1:0]  dprio_byteen,
    output              dprio_write,
    output      [15:0]  dprio_writedata,

    output  reg         atpgmode,
    output  reg         mdio_dis,
    output  reg         scanen,
    output  reg         ser_shift_load,
    output  reg         dprio_init_done
);

    reg [1:0] rst_n = 2'b00;
    reg [6:0] count = 7'd0;
    reg init_done_forever;

    // Internal versions of control signals
    wire  int_mdio_dis;
    wire  int_ser_shift_load;
    wire  int_dprio_init_done;
    wire  int_atpgmode;
    wire  int_scanen;


    assign  dprio_address   = count[6] ? 5'b0 : count[5:0] ;
    assign  dprio_byteen    = count[6] ? 2'b0 : 2'b11;      // always enabled
    assign  dprio_write     = ~count[6] & reset_n ;  // write for first 64 cycles
    assign  dprio_writedata = 16'd0;

    assign  int_ser_shift_load  = count[6] ? |count[2:1]  : 1'b1; 
    assign  int_mdio_dis        = count[6] ? ~count[2]    : 1'b1;
    assign  int_dprio_init_done = ~init_done_forever ? (count[6] ? &count[2:0]  : 1'b0)
                                                    : 1'b1;
    assign  int_atpgmode        = 0;
    assign  int_scanen          = 0;


    // reset synch.
    always @(posedge clk or negedge reset_n)
        if(!reset_n)  rst_n <= 2'b00;
        else          rst_n <= {rst_n[0],1'b1};

    // counter
    always @(posedge clk)
    begin
        if (count[6] && &count[1:0])
            init_done_forever <= 1'b1;
    end
    always @(posedge clk or negedge rst_n[1])
    begin
        if(!rst_n[1])
        begin
            count <= 7'd0;
        end
        else if(~int_dprio_init_done) 
        begin
            count <= count + 7'd1;
        end
        else
        begin
            count <= count;
        end
    end

    // outputs
    always @(posedge clk) begin
        mdio_dis        <= int_mdio_dis;
        ser_shift_load  <= int_ser_shift_load;
        dprio_init_done <= int_dprio_init_done;
        atpgmode        <= int_atpgmode;
        scanen          <= int_scanen;
    end

endmodule

(* altera_attribute = "-name PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF; -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF; -name ADV_NETLIST_OPT_SYNTH_WYSIWYG_REMAP OFF; -name REMOVE_REDUNDANT_LOGIC_CELLS OFF" *) module pll_dps_lcell_comb
#(
    //parameter
    parameter family             = "Stratix V",
    parameter lut_mask           = 64'hAAAAAAAAAAAAAAAA,
    parameter dont_touch         = "on"
) ( 

    input    dataa,
    input    datab,
    input    datac,
    input    datad,
    input    datae,
    input    dataf,

    output   combout
);

    generate
        if (family == "Stratix V")
        begin
            stratixv_lcell_comb lcell_inst (
                    .dataa(dataa),
                    .datab(datab),
                    .datac(datac),
                    .datad(datad),
                    .datae(datae),
                    .dataf(dataf),
                    .combout (combout));
            defparam lcell_inst.lut_mask = lut_mask;
            defparam lcell_inst.dont_touch = dont_touch;
        end
        else if (family == "Arria V")
        begin
            arriav_lcell_comb lcell_inst (
                    .dataa(dataa),
                    .datab(datab),
                    .datac(datac),
                    .datad(datad),
                    .datae(datae),
                    .dataf(dataf),
                    .combout (combout));
            defparam lcell_inst.lut_mask = lut_mask;
            defparam lcell_inst.dont_touch = dont_touch;
        end
        else if (family == "Arria V GZ")
        begin
            arriavgz_lcell_comb lcell_inst (
                    .dataa(dataa),
                    .datab(datab),
                    .datac(datac),
                    .datad(datad),
                    .datae(datae),
                    .dataf(dataf),
                    .combout (combout));
            defparam lcell_inst.lut_mask = lut_mask;
            defparam lcell_inst.dont_touch = dont_touch;
        end
        else if (family == "Cyclone V")
        begin
            cyclonev_lcell_comb lcell_inst (
                    .dataa(dataa),
                    .datab(datab),
                    .datac(datac),
                    .datad(datad),
                    .datae(datae),
                    .dataf(dataf),
                    .combout (combout));
            defparam lcell_inst.lut_mask = lut_mask;
            defparam lcell_inst.dont_touch = dont_touch;
        end
        endgenerate
endmodule
`timescale 1 ps/1 ps

module altera_stratixv_pll
#(	
	// Parameter declarations and default value assignments
	parameter number_of_counters = 18,	
	parameter number_of_fplls = 1,
	parameter number_of_extclks = 4,
	parameter number_of_dlls = 2,
	parameter number_of_lvds = 4,	

	// stratixv_pll_refclk_select parameters -- FF_PLL 0
	parameter pll_auto_clk_sw_en_0 = "false",
	parameter pll_clk_loss_edge_0 = "both_edges",
	parameter pll_clk_loss_sw_en_0 = "false",
	parameter pll_clk_sw_dly_0 = 0,
	parameter pll_clkin_0_src_0 = "clk_0",
	parameter pll_clkin_1_src_0 = "clk_0",
	parameter pll_manu_clk_sw_en_0 = "false",
	parameter pll_sw_refclk_src_0 = "clk_0",
	
	// stratixv_pll_refclk_select parameters -- FF_PLL 1
	parameter pll_auto_clk_sw_en_1 = "false",
	parameter pll_clk_loss_edge_1 = "both_edges",
	parameter pll_clk_loss_sw_en_1 = "false",
	parameter pll_clk_sw_dly_1 = 0,
	parameter pll_clkin_0_src_1 = "clk_1",
	parameter pll_clkin_1_src_1 = "clk_1",
	parameter pll_manu_clk_sw_en_1 = "false",
	parameter pll_sw_refclk_src_1 = "clk_1",
	
	// stratixv_fractional_pll parameters -- FF_PLL 0
	parameter pll_output_clock_frequency_0 = "700.0 MHz",
	parameter reference_clock_frequency_0 = "700.0 MHz",
	parameter mimic_fbclk_type_0 = "gclk",
	parameter dsm_accumulator_reset_value_0 = 0,
	parameter forcelock_0 = "false",
	parameter nreset_invert_0 = "false",
	parameter pll_atb_0 = 0,
	parameter pll_bwctrl_0 = 1000,
	parameter pll_cmp_buf_dly_0 = "0 ps",
	parameter pll_cp_comp_0 = "true",
	parameter pll_cp_current_0 = 20,
	parameter pll_ctrl_override_setting_0 = "true",
	parameter pll_dsm_dither_0 = "disable",
	parameter pll_dsm_out_sel_0 = "disable",
	parameter pll_dsm_reset_0 = "false",
	parameter pll_ecn_bypass_0 = "false",
	parameter pll_ecn_test_en_0 = "false",
	parameter pll_enable_0 = "true",
	parameter pll_fbclk_mux_1_0 = "fb",
	parameter pll_fbclk_mux_2_0 = "m_cnt",
	parameter pll_fractional_carry_out_0 = 24,
	parameter pll_fractional_division_0 = 1,
	parameter pll_fractional_value_ready_0 = "true",
	parameter pll_lf_testen_0 = "false",
	parameter pll_lock_fltr_cfg_0 = 25,
	parameter pll_lock_fltr_test_0 = "false",
	parameter pll_m_cnt_bypass_en_0 = "false",
	parameter pll_m_cnt_coarse_dly_0 = "0 ps",
	parameter pll_m_cnt_fine_dly_0 = "0 ps",
	parameter pll_m_cnt_hi_div_0 = 3,
	parameter pll_m_cnt_in_src_0 = "ph_mux_clk",
	parameter pll_m_cnt_lo_div_0 = 3,
	parameter pll_m_cnt_odd_div_duty_en_0 = "false",
	parameter pll_m_cnt_ph_mux_prst_0 = 0,
	parameter pll_m_cnt_prst_0 = 256,
	parameter pll_n_cnt_bypass_en_0 = "true",
	parameter pll_n_cnt_coarse_dly_0 = "0 ps",
	parameter pll_n_cnt_fine_dly_0 = "0 ps",
	parameter pll_n_cnt_hi_div_0 = 1,
	parameter pll_n_cnt_lo_div_0 = 1,
	parameter pll_n_cnt_odd_div_duty_en_0 = "false",
	parameter pll_ref_buf_dly_0 = "0 ps",
	parameter pll_reg_boost_0 = 0,
	parameter pll_regulator_bypass_0 = "false",
	parameter pll_ripplecap_ctrl_0 = 0,
	parameter pll_slf_rst_0 = "false",
	parameter pll_tclk_mux_en_0 = "false",
	parameter pll_tclk_sel_0 = "n_src",
	parameter pll_test_enable_0 = "false",
	parameter pll_testdn_enable_0 = "false",
	parameter pll_testup_enable_0 = "false",
	parameter pll_unlock_fltr_cfg_0 = 1,
	parameter pll_vco_div_0 = 0,
	parameter pll_vco_ph0_en_0 = "true",
	parameter pll_vco_ph1_en_0 = "true",
	parameter pll_vco_ph2_en_0 = "true",
	parameter pll_vco_ph3_en_0 = "true",
	parameter pll_vco_ph4_en_0 = "true",
	parameter pll_vco_ph5_en_0 = "true",
	parameter pll_vco_ph6_en_0 = "true",
	parameter pll_vco_ph7_en_0 = "true",
	parameter pll_vctrl_test_voltage_0 = 750,
	parameter vccd0g_atb_0 = "disable",
	parameter vccd0g_output_0 = 0,
	parameter vccd1g_atb_0 = "disable",
	parameter vccd1g_output_0 = 0,
	parameter vccm1g_tap_0 = 2,
	parameter vccr_pd_0 = "false",
	parameter vcodiv_override_0 = "false",
    parameter sim_use_fast_model_0 = "false",

	// stratixv_fractional_pll parameters -- FF_PLL 1
	parameter pll_output_clock_frequency_1 = "300.0 MHz",
	parameter reference_clock_frequency_1 = "100.0 MHz",
	parameter mimic_fbclk_type_1 = "gclk",
	parameter dsm_accumulator_reset_value_1 = 0,
	parameter forcelock_1 = "false",
	parameter nreset_invert_1 = "false",
	parameter pll_atb_1 = 0,
	parameter pll_bwctrl_1 = 1000,
	parameter pll_cmp_buf_dly_1 = "0 ps",
	parameter pll_cp_comp_1 = "true",
	parameter pll_cp_current_1 = 30,
	parameter pll_ctrl_override_setting_1 = "false",
	parameter pll_dsm_dither_1 = "disable",
	parameter pll_dsm_out_sel_1 = "disable",
	parameter pll_dsm_reset_1 = "false",
	parameter pll_ecn_bypass_1 = "false",
	parameter pll_ecn_test_en_1 = "false",
	parameter pll_enable_1 = "false",
	parameter pll_fbclk_mux_1_1 = "glb",
	parameter pll_fbclk_mux_2_1 = "fb_1",
	parameter pll_fractional_carry_out_1 = 24,
	parameter pll_fractional_division_1 = 1,
	parameter pll_fractional_value_ready_1 = "true",
	parameter pll_lf_testen_1 = "false",
	parameter pll_lock_fltr_cfg_1 = 25,
	parameter pll_lock_fltr_test_1 = "false",
	parameter pll_m_cnt_bypass_en_1 = "false",
	parameter pll_m_cnt_coarse_dly_1 = "0 ps",
	parameter pll_m_cnt_fine_dly_1 = "0 ps",
	parameter pll_m_cnt_hi_div_1 = 2,
	parameter pll_m_cnt_in_src_1 = "ph_mux_clk",
	parameter pll_m_cnt_lo_div_1 = 1,
	parameter pll_m_cnt_odd_div_duty_en_1 = "true",
	parameter pll_m_cnt_ph_mux_prst_1 = 0,
	parameter pll_m_cnt_prst_1 = 256,
	parameter pll_n_cnt_bypass_en_1 = "true",
	parameter pll_n_cnt_coarse_dly_1 = "0 ps",
	parameter pll_n_cnt_fine_dly_1 = "0 ps",
	parameter pll_n_cnt_hi_div_1 = 256,
	parameter pll_n_cnt_lo_div_1 = 256,
	parameter pll_n_cnt_odd_div_duty_en_1 = "false",
	parameter pll_ref_buf_dly_1 = "0 ps",
	parameter pll_reg_boost_1 = 0,
	parameter pll_regulator_bypass_1 = "false",
	parameter pll_ripplecap_ctrl_1 = 0,
	parameter pll_slf_rst_1 = "false",
	parameter pll_tclk_mux_en_1 = "false",
	parameter pll_tclk_sel_1 = "n_src",
	parameter pll_test_enable_1 = "false",
	parameter pll_testdn_enable_1 = "false",
	parameter pll_testup_enable_1 = "false",
	parameter pll_unlock_fltr_cfg_1 = 2,
	parameter pll_vco_div_1 = 1,
	parameter pll_vco_ph0_en_1 = "true",
	parameter pll_vco_ph1_en_1 = "true",
	parameter pll_vco_ph2_en_1 = "true",
	parameter pll_vco_ph3_en_1 = "true",
	parameter pll_vco_ph4_en_1 = "true",
	parameter pll_vco_ph5_en_1 = "true",
	parameter pll_vco_ph6_en_1 = "true",
	parameter pll_vco_ph7_en_1 = "true",
	parameter pll_vctrl_test_voltage_1 = 750,
	parameter vccd0g_atb_1 = "disable",
	parameter vccd0g_output_1 = 0,
	parameter vccd1g_atb_1 = "disable",
	parameter vccd1g_output_1 = 0,
	parameter vccm1g_tap_1 = 2,
	parameter vccr_pd_1 = "false",
	parameter vcodiv_override_1 = "false",
    parameter sim_use_fast_model_1 = "false",
    
	// stratixv_pll_output_counter parameters -- counter 0
	parameter output_clock_frequency_0 = "100.0 MHz",
	parameter enable_output_counter_0 = "true",
	parameter phase_shift_0 = "0 ps",
	parameter duty_cycle_0 = 50,
	parameter c_cnt_coarse_dly_0 = "0 ps",
	parameter c_cnt_fine_dly_0 = "0 ps",
	parameter c_cnt_in_src_0 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_0 = 0,
	parameter c_cnt_prst_0 = 1,
	parameter cnt_fpll_src_0 = "fpll_0",
	parameter dprio0_cnt_bypass_en_0 = "true",
	parameter dprio0_cnt_hi_div_0 = 3,
	parameter dprio0_cnt_lo_div_0 = 3,
	parameter dprio0_cnt_odd_div_even_duty_en_0 = "false",
	parameter dprio1_cnt_bypass_en_0 = dprio0_cnt_bypass_en_0,
	parameter dprio1_cnt_hi_div_0 = dprio0_cnt_hi_div_0,
	parameter dprio1_cnt_lo_div_0 = dprio0_cnt_lo_div_0,
	parameter dprio1_cnt_odd_div_even_duty_en_0 = dprio0_cnt_odd_div_even_duty_en_0,
	
	parameter output_clock_frequency_1 = "0 ps",
	parameter enable_output_counter_1 = "true",
	parameter phase_shift_1 = "0 ps",
	parameter duty_cycle_1 = 50,
	parameter c_cnt_coarse_dly_1 = "0 ps",
	parameter c_cnt_fine_dly_1 = "0 ps",
	parameter c_cnt_in_src_1 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_1 = 0,
	parameter c_cnt_prst_1 = 1,
	parameter cnt_fpll_src_1 = "fpll_0",
	parameter dprio0_cnt_bypass_en_1 = "true",
	parameter dprio0_cnt_hi_div_1 = 2,
	parameter dprio0_cnt_lo_div_1 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_1 = "true",
	parameter dprio1_cnt_bypass_en_1 = dprio0_cnt_bypass_en_1,
	parameter dprio1_cnt_hi_div_1 = dprio0_cnt_hi_div_1,
	parameter dprio1_cnt_lo_div_1 = dprio0_cnt_lo_div_1,
	parameter dprio1_cnt_odd_div_even_duty_en_1 = dprio0_cnt_odd_div_even_duty_en_1,
	
	parameter output_clock_frequency_2 = "0 ps",
	parameter enable_output_counter_2 = "true",
	parameter phase_shift_2 = "0 ps",
	parameter duty_cycle_2 = 50,
	parameter c_cnt_coarse_dly_2 = "0 ps",
	parameter c_cnt_fine_dly_2 = "0 ps",
	parameter c_cnt_in_src_2 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_2 = 0,
	parameter c_cnt_prst_2 = 1,
	parameter cnt_fpll_src_2 = "fpll_0",
	parameter dprio0_cnt_bypass_en_2 = "true",
	parameter dprio0_cnt_hi_div_2 = 1,
	parameter dprio0_cnt_lo_div_2 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_2 = "false",
	parameter dprio1_cnt_bypass_en_2 = dprio0_cnt_bypass_en_2,
	parameter dprio1_cnt_hi_div_2 = dprio0_cnt_hi_div_2,
	parameter dprio1_cnt_lo_div_2 = dprio0_cnt_lo_div_2,
	parameter dprio1_cnt_odd_div_even_duty_en_2 = dprio0_cnt_odd_div_even_duty_en_2,
	
	parameter output_clock_frequency_3 = "0 ps",
	parameter enable_output_counter_3 = "true",
	parameter phase_shift_3 = "0 ps",
	parameter duty_cycle_3 = 50,
	parameter c_cnt_coarse_dly_3 = "0 ps",
	parameter c_cnt_fine_dly_3 = "0 ps",
	parameter c_cnt_in_src_3 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_3 = 0,
	parameter c_cnt_prst_3 = 1,
	parameter cnt_fpll_src_3 = "fpll_0",
	parameter dprio0_cnt_bypass_en_3 = "false",
	parameter dprio0_cnt_hi_div_3 = 1,
	parameter dprio0_cnt_lo_div_3 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_3 = "false",
	parameter dprio1_cnt_bypass_en_3 = dprio0_cnt_bypass_en_3,
	parameter dprio1_cnt_hi_div_3 = dprio0_cnt_hi_div_3,
	parameter dprio1_cnt_lo_div_3 = dprio0_cnt_lo_div_3,
	parameter dprio1_cnt_odd_div_even_duty_en_3 = dprio0_cnt_odd_div_even_duty_en_3,
	
	parameter output_clock_frequency_4 = "0 ps",
	parameter enable_output_counter_4 = "true",
	parameter phase_shift_4 = "0 ps",
	parameter duty_cycle_4 = 50,
	parameter c_cnt_coarse_dly_4 = "0 ps",
	parameter c_cnt_fine_dly_4 = "0 ps",
	parameter c_cnt_in_src_4 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_4 = 0,
	parameter c_cnt_prst_4 = 1,
	parameter cnt_fpll_src_4 = "fpll_0",
	parameter dprio0_cnt_bypass_en_4 = "false",
	parameter dprio0_cnt_hi_div_4 = 1,
	parameter dprio0_cnt_lo_div_4 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_4 = "false",
	parameter dprio1_cnt_bypass_en_4 = dprio0_cnt_bypass_en_4,
	parameter dprio1_cnt_hi_div_4 = dprio0_cnt_hi_div_4,
	parameter dprio1_cnt_lo_div_4 = dprio0_cnt_lo_div_4,
	parameter dprio1_cnt_odd_div_even_duty_en_4 = dprio0_cnt_odd_div_even_duty_en_4,
	
	parameter output_clock_frequency_5 = "0 ps",
	parameter enable_output_counter_5 = "true",
	parameter phase_shift_5 = "0 ps",
	parameter duty_cycle_5 = 50,
	parameter c_cnt_coarse_dly_5 = "0 ps",
	parameter c_cnt_fine_dly_5 = "0 ps",
	parameter c_cnt_in_src_5 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_5 = 0,
	parameter c_cnt_prst_5 = 1,
	parameter cnt_fpll_src_5 = "fpll_0",
	parameter dprio0_cnt_bypass_en_5 = "false",
	parameter dprio0_cnt_hi_div_5 = 1,
	parameter dprio0_cnt_lo_div_5 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_5 = "false",
	parameter dprio1_cnt_bypass_en_5 = dprio0_cnt_bypass_en_5,
	parameter dprio1_cnt_hi_div_5 = dprio0_cnt_hi_div_5,
	parameter dprio1_cnt_lo_div_5 = dprio0_cnt_lo_div_5,
	parameter dprio1_cnt_odd_div_even_duty_en_5 = dprio0_cnt_odd_div_even_duty_en_5,
	
	parameter output_clock_frequency_6 = "0 ps",
	parameter enable_output_counter_6 = "true",
	parameter phase_shift_6 = "0 ps",
	parameter duty_cycle_6 = 50,
	parameter c_cnt_coarse_dly_6 = "0 ps",
	parameter c_cnt_fine_dly_6 = "0 ps",
	parameter c_cnt_in_src_6 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_6 = 0,
	parameter c_cnt_prst_6 = 1,
	parameter cnt_fpll_src_6 = "fpll_0",
	parameter dprio0_cnt_bypass_en_6 = "false",
	parameter dprio0_cnt_hi_div_6 = 1,
	parameter dprio0_cnt_lo_div_6 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_6 = "false",
	parameter dprio1_cnt_bypass_en_6 = dprio0_cnt_bypass_en_6,
	parameter dprio1_cnt_hi_div_6 = dprio0_cnt_hi_div_6,
	parameter dprio1_cnt_lo_div_6 = dprio0_cnt_lo_div_6,
	parameter dprio1_cnt_odd_div_even_duty_en_6 = dprio0_cnt_odd_div_even_duty_en_6,
	
	parameter output_clock_frequency_7 = "0 ps",
	parameter enable_output_counter_7 = "true",
	parameter phase_shift_7 = "0 ps",
	parameter duty_cycle_7 = 50,
	parameter c_cnt_coarse_dly_7 = "0 ps",
	parameter c_cnt_fine_dly_7 = "0 ps",
	parameter c_cnt_in_src_7 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_7 = 0,
	parameter c_cnt_prst_7 = 1,
	parameter cnt_fpll_src_7 = "fpll_0",
	parameter dprio0_cnt_bypass_en_7 = "false",
	parameter dprio0_cnt_hi_div_7 = 1,
	parameter dprio0_cnt_lo_div_7 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_7 = "false",
	parameter dprio1_cnt_bypass_en_7 = dprio0_cnt_bypass_en_7,
	parameter dprio1_cnt_hi_div_7 = dprio0_cnt_hi_div_7,
	parameter dprio1_cnt_lo_div_7 = dprio0_cnt_lo_div_7,
	parameter dprio1_cnt_odd_div_even_duty_en_7 = dprio0_cnt_odd_div_even_duty_en_7,
	
	parameter output_clock_frequency_8 = "0 ps",
	parameter enable_output_counter_8 = "true",
	parameter phase_shift_8 = "0 ps",
	parameter duty_cycle_8 = 50,
	parameter c_cnt_coarse_dly_8 = "0 ps",
	parameter c_cnt_fine_dly_8 = "0 ps",
	parameter c_cnt_in_src_8 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_8 = 0,
	parameter c_cnt_prst_8 = 1,
	parameter cnt_fpll_src_8 = "fpll_0",
	parameter dprio0_cnt_bypass_en_8 = "false",
	parameter dprio0_cnt_hi_div_8 = 1,
	parameter dprio0_cnt_lo_div_8 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_8 = "false",
	parameter dprio1_cnt_bypass_en_8 = dprio0_cnt_bypass_en_8,
	parameter dprio1_cnt_hi_div_8 = dprio0_cnt_hi_div_8,
	parameter dprio1_cnt_lo_div_8 = dprio0_cnt_lo_div_8,
	parameter dprio1_cnt_odd_div_even_duty_en_8 = dprio0_cnt_odd_div_even_duty_en_8,
	
	parameter output_clock_frequency_9 = "0 ps",
	parameter enable_output_counter_9 = "true",
	parameter phase_shift_9 = "0 ps",
	parameter duty_cycle_9 = 50,
	parameter c_cnt_coarse_dly_9 = "0 ps",
	parameter c_cnt_fine_dly_9 = "0 ps",
	parameter c_cnt_in_src_9 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_9 = 0,
	parameter c_cnt_prst_9 = 1,
	parameter cnt_fpll_src_9 = "fpll_0",
	parameter dprio0_cnt_bypass_en_9 = "false",
	parameter dprio0_cnt_hi_div_9 = 1,
	parameter dprio0_cnt_lo_div_9 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_9 = "false",
	parameter dprio1_cnt_bypass_en_9 = dprio0_cnt_bypass_en_9,
	parameter dprio1_cnt_hi_div_9 = dprio0_cnt_hi_div_9,
	parameter dprio1_cnt_lo_div_9 = dprio0_cnt_lo_div_9,
	parameter dprio1_cnt_odd_div_even_duty_en_9 = dprio0_cnt_odd_div_even_duty_en_9,
	
	parameter output_clock_frequency_10 = "0 ps",
	parameter enable_output_counter_10 = "true",
	parameter phase_shift_10 = "0 ps",
	parameter duty_cycle_10 = 50,
	parameter c_cnt_coarse_dly_10 = "0 ps",
	parameter c_cnt_fine_dly_10 = "0 ps",
	parameter c_cnt_in_src_10 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_10 = 0,
	parameter c_cnt_prst_10 = 1,
	parameter cnt_fpll_src_10 = "fpll_0",
	parameter dprio0_cnt_bypass_en_10 = "false",
	parameter dprio0_cnt_hi_div_10 = 1,
	parameter dprio0_cnt_lo_div_10 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_10 = "false",
	parameter dprio1_cnt_bypass_en_10 = dprio0_cnt_bypass_en_10,
	parameter dprio1_cnt_hi_div_10 = dprio0_cnt_hi_div_10,
	parameter dprio1_cnt_lo_div_10 = dprio0_cnt_lo_div_10,
	parameter dprio1_cnt_odd_div_even_duty_en_10 = dprio0_cnt_odd_div_even_duty_en_10,
	
	parameter output_clock_frequency_11 = "0 ps",
	parameter enable_output_counter_11 = "true",
	parameter phase_shift_11 = "0 ps",
	parameter duty_cycle_11 = 50,
	parameter c_cnt_coarse_dly_11 = "0 ps",
	parameter c_cnt_fine_dly_11 = "0 ps",
	parameter c_cnt_in_src_11 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_11 = 0,
	parameter c_cnt_prst_11 = 1,
	parameter cnt_fpll_src_11 = "fpll_0",
	parameter dprio0_cnt_bypass_en_11 = "false",
	parameter dprio0_cnt_hi_div_11 = 1,
	parameter dprio0_cnt_lo_div_11 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_11 = "false",
	parameter dprio1_cnt_bypass_en_11 = dprio0_cnt_bypass_en_11,
	parameter dprio1_cnt_hi_div_11 = dprio0_cnt_hi_div_11,
	parameter dprio1_cnt_lo_div_11 = dprio0_cnt_lo_div_11,
	parameter dprio1_cnt_odd_div_even_duty_en_11 = dprio0_cnt_odd_div_even_duty_en_11,
	
	parameter output_clock_frequency_12 = "0 ps",
	parameter enable_output_counter_12 = "true",
	parameter phase_shift_12 = "0 ps",
	parameter duty_cycle_12 = 50,
	parameter c_cnt_coarse_dly_12 = "0 ps",
	parameter c_cnt_fine_dly_12 = "0 ps",
	parameter c_cnt_in_src_12 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_12 = 0,
	parameter c_cnt_prst_12 = 1,
	parameter cnt_fpll_src_12 = "fpll_0",
	parameter dprio0_cnt_bypass_en_12 = "false",
	parameter dprio0_cnt_hi_div_12 = 1,
	parameter dprio0_cnt_lo_div_12 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_12 = "false",
	parameter dprio1_cnt_bypass_en_12 = dprio0_cnt_bypass_en_12,
	parameter dprio1_cnt_hi_div_12 = dprio0_cnt_hi_div_12,
	parameter dprio1_cnt_lo_div_12 = dprio0_cnt_lo_div_12,
	parameter dprio1_cnt_odd_div_even_duty_en_12 = dprio0_cnt_odd_div_even_duty_en_12,
	
	parameter output_clock_frequency_13 = "0 ps",
	parameter enable_output_counter_13 = "true",
	parameter phase_shift_13 = "0 ps",
	parameter duty_cycle_13 = 50,
	parameter c_cnt_coarse_dly_13 = "0 ps",
	parameter c_cnt_fine_dly_13 = "0 ps",
	parameter c_cnt_in_src_13 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_13 = 0,
	parameter c_cnt_prst_13 = 1,
	parameter cnt_fpll_src_13 = "fpll_0",
	parameter dprio0_cnt_bypass_en_13 = "false",
	parameter dprio0_cnt_hi_div_13 = 1,
	parameter dprio0_cnt_lo_div_13 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_13 = "false",
	parameter dprio1_cnt_bypass_en_13 = dprio0_cnt_bypass_en_13,
	parameter dprio1_cnt_hi_div_13 = dprio0_cnt_hi_div_13,
	parameter dprio1_cnt_lo_div_13 = dprio0_cnt_lo_div_13,
	parameter dprio1_cnt_odd_div_even_duty_en_13 = dprio0_cnt_odd_div_even_duty_en_13,
	
	parameter output_clock_frequency_14 = "0 ps",
	parameter enable_output_counter_14 = "true",
	parameter phase_shift_14 = "0 ps",
	parameter duty_cycle_14 = 50,
	parameter c_cnt_coarse_dly_14 = "0 ps",
	parameter c_cnt_fine_dly_14 = "0 ps",
	parameter c_cnt_in_src_14 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_14 = 0,
	parameter c_cnt_prst_14 = 1,
	parameter cnt_fpll_src_14 = "fpll_0",
	parameter dprio0_cnt_bypass_en_14 = "false",
	parameter dprio0_cnt_hi_div_14 = 1,
	parameter dprio0_cnt_lo_div_14 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_14 = "false",
	parameter dprio1_cnt_bypass_en_14 = dprio0_cnt_bypass_en_14,
	parameter dprio1_cnt_hi_div_14 = dprio0_cnt_hi_div_14,
	parameter dprio1_cnt_lo_div_14 = dprio0_cnt_lo_div_14,
	parameter dprio1_cnt_odd_div_even_duty_en_14 = dprio0_cnt_odd_div_even_duty_en_14,
	
	parameter output_clock_frequency_15 = "0 ps",
	parameter enable_output_counter_15 = "true",
	parameter phase_shift_15 = "0 ps",
	parameter duty_cycle_15 = 50,
	parameter c_cnt_coarse_dly_15 = "0 ps",
	parameter c_cnt_fine_dly_15 = "0 ps",
	parameter c_cnt_in_src_15 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_15 = 0,
	parameter c_cnt_prst_15 = 1,
	parameter cnt_fpll_src_15 = "fpll_0",
	parameter dprio0_cnt_bypass_en_15 = "false",
	parameter dprio0_cnt_hi_div_15 = 1,
	parameter dprio0_cnt_lo_div_15 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_15 = "false",
	parameter dprio1_cnt_bypass_en_15 = dprio0_cnt_bypass_en_15,
	parameter dprio1_cnt_hi_div_15 = dprio0_cnt_hi_div_15,
	parameter dprio1_cnt_lo_div_15 = dprio0_cnt_lo_div_15,
	parameter dprio1_cnt_odd_div_even_duty_en_15 = dprio0_cnt_odd_div_even_duty_en_15,
	
	parameter output_clock_frequency_16 = "0 ps",
	parameter enable_output_counter_16 = "true",
	parameter phase_shift_16 = "0 ps",
	parameter duty_cycle_16 = 50,
	parameter c_cnt_coarse_dly_16 = "0 ps",
	parameter c_cnt_fine_dly_16 = "0 ps",
	parameter c_cnt_in_src_16 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_16 = 0,
	parameter c_cnt_prst_16 = 1,
	parameter cnt_fpll_src_16 = "fpll_0",
	parameter dprio0_cnt_bypass_en_16 = "false",
	parameter dprio0_cnt_hi_div_16 = 1,
	parameter dprio0_cnt_lo_div_16 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_16 = "false",
	parameter dprio1_cnt_bypass_en_16 = dprio0_cnt_bypass_en_16,
	parameter dprio1_cnt_hi_div_16 = dprio0_cnt_hi_div_16,
	parameter dprio1_cnt_lo_div_16 = dprio0_cnt_lo_div_16,
	parameter dprio1_cnt_odd_div_even_duty_en_16 = dprio0_cnt_odd_div_even_duty_en_16,
	
	parameter output_clock_frequency_17 = "0 ps",
	parameter enable_output_counter_17 = "true",
	parameter phase_shift_17 = "0 ps",
	parameter duty_cycle_17 = 50,
	parameter c_cnt_coarse_dly_17 = "0 ps",
	parameter c_cnt_fine_dly_17 = "0 ps",
	parameter c_cnt_in_src_17 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_17 = 0,
	parameter c_cnt_prst_17 = 1,
	parameter cnt_fpll_src_17 = "fpll_0",
	parameter dprio0_cnt_bypass_en_17 = "false",
	parameter dprio0_cnt_hi_div_17 = 1,
	parameter dprio0_cnt_lo_div_17 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_17 = "false",
	parameter dprio1_cnt_bypass_en_17 = dprio0_cnt_bypass_en_17,
	parameter dprio1_cnt_hi_div_17 = dprio0_cnt_hi_div_17,
	parameter dprio1_cnt_lo_div_17 = dprio0_cnt_lo_div_17,
	parameter dprio1_cnt_odd_div_even_duty_en_17 = dprio0_cnt_odd_div_even_duty_en_17,

	// stratixv_pll_dpa_output parameters -- dpa_output 0
	parameter dpa_output_clock_frequency_0 = "0 ps",
	parameter pll_vcoph_div_0 = 1,

	parameter dpa_output_clock_frequency_1 = "0 ps",
	parameter pll_vcoph_div_1 = 1,
	
	// stratixv_pll_extclk_output parameters -- extclk 0
	parameter enable_extclk_output_0 = "false",
	parameter pll_extclk_cnt_src_0 = "vss",
	parameter pll_extclk_enable_0 = "true",
	parameter pll_extclk_invert_0 = "false",
	
	parameter enable_extclk_output_1 = "false",
	parameter pll_extclk_cnt_src_1 = "vss",
	parameter pll_extclk_enable_1 = "true",
	parameter pll_extclk_invert_1 = "false",
	
	parameter enable_extclk_output_2 = "false",
	parameter pll_extclk_cnt_src_2 = "vss",
	parameter pll_extclk_enable_2 = "true",
	parameter pll_extclk_invert_2 = "false",
	
	parameter enable_extclk_output_3 = "false",
	parameter pll_extclk_cnt_src_3 = "vss",
	parameter pll_extclk_enable_3 = "true",
	parameter pll_extclk_invert_3 = "false",
	
	// stratixv_pll_dll_output parameters -- dll_output 0
	parameter enable_dll_output_0 = "false",
	parameter pll_dll_src_value_0 = "vss",
	
	parameter enable_dll_output_1 = "false",
	parameter pll_dll_src_value_1 = "vss",

	// stratixv_pll_lvds_output parameters -- lvds_output 0
	parameter enable_lvds_output_0 = "false",
	parameter pll_loaden_coarse_dly_0 = "0 ps",
	parameter pll_loaden_enable_disable_0 = "true",
	parameter pll_loaden_fine_dly_0 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_0 = "0 ps",
	parameter pll_lvdsclk_enable_disable_0 = "true",
	parameter pll_lvdsclk_fine_dly_0 = "0 ps",

	parameter enable_lvds_output_1 = "false",
	parameter pll_loaden_coarse_dly_1 = "0 ps",
	parameter pll_loaden_enable_disable_1 = "true",
	parameter pll_loaden_fine_dly_1 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_1 = "0 ps",
	parameter pll_lvdsclk_enable_disable_1 = "true",
	parameter pll_lvdsclk_fine_dly_1 = "0 ps",

	parameter enable_lvds_output_2 = "false",
	parameter pll_loaden_coarse_dly_2 = "0 ps",
	parameter pll_loaden_enable_disable_2 = "true",
	parameter pll_loaden_fine_dly_2 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_2 = "0 ps",
	parameter pll_lvdsclk_enable_disable_2 = "true",
	parameter pll_lvdsclk_fine_dly_2 = "0 ps",

	parameter enable_lvds_output_3 = "false",
	parameter pll_loaden_coarse_dly_3 = "0 ps",
	parameter pll_loaden_enable_disable_3 = "true",
	parameter pll_loaden_fine_dly_3 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_3 = "0 ps",
	parameter pll_lvdsclk_enable_disable_3 = "true",
	parameter pll_lvdsclk_fine_dly_3 = "0 ps"
)
(
	// stratixv_pll_dpa_output pins
	output [7:0] phout_0,
	output [7:0] phout_1,

	// stratixv_pll_refclk_select pins
	input [number_of_fplls-1:0] adjpllin,	
	input [number_of_fplls-1:0] cclk,
	input [number_of_fplls-1:0] coreclkin,
	input [number_of_fplls-1:0] extswitch,
	input [number_of_fplls-1:0] iqtxrxclkin,
	input [number_of_fplls-1:0] plliqclkin,
	input [number_of_fplls-1:0] rxiqclkin,
	input [3:0] clkin,
	input [1:0] refiqclk_0,
	input [1:0] refiqclk_1,
	output [number_of_fplls-1:0] clk0bad,
	output [number_of_fplls-1:0] clk1bad,
	output [number_of_fplls-1:0] pllclksel,

// stratixv_pll_reconfig pins
	input [number_of_fplls-1:0] atpgmode,
	input [number_of_fplls-1:0] clk,
	input [number_of_fplls-1:0] fpllcsrtest,
	input [number_of_fplls-1:0] iocsrclkin,
	input [number_of_fplls-1:0] iocsrdatain,
	input [number_of_fplls-1:0] iocsren,
	input [number_of_fplls-1:0] iocsrrstn,
	input [number_of_fplls-1:0] mdiodis,
	input [number_of_fplls-1:0] phaseen,
	input [number_of_fplls-1:0] read,
	input [number_of_fplls-1:0] rstn,
	input [number_of_fplls-1:0] scanen,
	input [number_of_fplls-1:0] sershiftload,
	input [number_of_fplls-1:0] shiftdonei,
	input [number_of_fplls-1:0] updn,
	input [number_of_fplls-1:0] write,
	input [5:0] addr_0,
	input [5:0] addr_1,
	input [1:0] byteen_0,
	input [1:0] byteen_1,
	input [4:0] cntsel_0,
	input [4:0] cntsel_1,
	input [15:0] din_0,
	input [15:0] din_1,
	output [number_of_fplls-1:0] blockselect,
	output [number_of_fplls-1:0] iocsrdataout,
	output [number_of_fplls-1:0] iocsrenbuf,
	output [number_of_fplls-1:0] iocsrrstnbuf,
	output [number_of_fplls-1:0] phasedone,
	output [15:0] dout_0,
	output [15:0] dout_1,
	output [815:0] dprioout_0,
	output [815:0] dprioout_1,

// stratixv_fractional_pll pins
	input [number_of_fplls-1:0] fbclkfpll,
	input [number_of_fplls-1:0] lvdfbin,
	input [number_of_fplls-1:0] nresync,
	input [number_of_fplls-1:0] pfden,
	input [number_of_fplls-1:0] shiften_fpll,
	input [number_of_fplls-1:0] zdb,
	output [number_of_fplls-1:0] fblvdsout,
	output [number_of_fplls-1:0] lock,
	output [number_of_fplls-1:0] mcntout,
	output [number_of_fplls-1:0] plniotribuf,

// stratixv_pll_extclk_output pins
	input [number_of_extclks-1:0] clken,
	output [number_of_extclks-1:0] extclk,

// stratixv_pll_dll_output pins
	input [number_of_dlls-1:0] dll_clkin,
	output [number_of_dlls-1:0] clkout,

// stratixv_pll_lvds_output pins
	output [number_of_lvds-1:0] loaden,
	output [number_of_lvds-1:0] lvdsclk,

// stratixv_pll_output_counter pins
	output [number_of_counters-1:0] divclk,
	output [number_of_counters-1:0] cascade_out	
);

////////////////////////////////////////////////////////////////////////////////
// pll_clkin_0_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLKIN_0_SRC_PLL_IQCLK = 4'b1100 ;
localparam PLL_CLKIN_0_SRC_FPLL = 4'b1011 ;
localparam PLL_CLKIN_0_SRC_IQTXRXCLK = 4'b1010 ;
localparam PLL_CLKIN_0_SRC_CMU_IQCLK = 4'b1001 ;
localparam PLL_CLKIN_0_SRC_VSS = 4'b1000 ;
localparam PLL_CLKIN_0_SRC_CLK_3 = 4'b0111 ;
localparam PLL_CLKIN_0_SRC_CLK_2 = 4'b0110 ;
localparam PLL_CLKIN_0_SRC_CLK_1 = 4'b0101 ;
localparam PLL_CLKIN_0_SRC_CLK_0 = 4'b0100 ;
localparam PLL_CLKIN_0_SRC_REF_CLK1 = 4'b0011 ;
localparam PLL_CLKIN_0_SRC_REF_CLK0 = 4'b0010 ;
localparam PLL_CLKIN_0_SRC_ADJ_PLL_CLK = 4'b0001 ;
localparam PLL_CLKIN_0_SRC_CORE_REF_CLK = 4'b0000 ;
localparam local_pll_clkin_0_src_0 = (pll_clkin_0_src_0 == "core_ref_clk") ? PLL_CLKIN_0_SRC_CORE_REF_CLK :
								   (pll_clkin_0_src_0 == "adj_pll_clk") ? PLL_CLKIN_0_SRC_ADJ_PLL_CLK :
								   (pll_clkin_0_src_0 == "ref_clk0") ? PLL_CLKIN_0_SRC_REF_CLK0 :
								   (pll_clkin_0_src_0 == "ref_clk1") ? PLL_CLKIN_0_SRC_REF_CLK1 :
								   (pll_clkin_0_src_0 == "clk_0") ? PLL_CLKIN_0_SRC_CLK_0 :
								   (pll_clkin_0_src_0 == "clk_1") ? PLL_CLKIN_0_SRC_CLK_1 :
								   (pll_clkin_0_src_0 == "clk_2") ? PLL_CLKIN_0_SRC_CLK_2 :
								   (pll_clkin_0_src_0 == "clk_3") ? PLL_CLKIN_0_SRC_CLK_3 :
								   (pll_clkin_0_src_0 == "vss") ? PLL_CLKIN_0_SRC_VSS :
								   (pll_clkin_0_src_0 == "cmu_iqclk") ? PLL_CLKIN_0_SRC_CMU_IQCLK :
								   (pll_clkin_0_src_0 == "iqtxrxclk") ? PLL_CLKIN_0_SRC_IQTXRXCLK :
								   (pll_clkin_0_src_0 == "fpll") ? PLL_CLKIN_0_SRC_FPLL :
								   (pll_clkin_0_src_0 == "pll_iqclk") ? PLL_CLKIN_0_SRC_PLL_IQCLK : PLL_CLKIN_0_SRC_VSS;
localparam local_pll_clkin_0_src_1 = (pll_clkin_0_src_1 == "core_ref_clk") ? PLL_CLKIN_0_SRC_CORE_REF_CLK :
								   (pll_clkin_0_src_1 == "adj_pll_clk") ? PLL_CLKIN_0_SRC_ADJ_PLL_CLK :
								   (pll_clkin_0_src_1 == "ref_clk0") ? PLL_CLKIN_0_SRC_REF_CLK0 :
								   (pll_clkin_0_src_1 == "ref_clk1") ? PLL_CLKIN_0_SRC_REF_CLK1 :
								   (pll_clkin_0_src_1 == "clk_0") ? PLL_CLKIN_0_SRC_CLK_0 :
								   (pll_clkin_0_src_1 == "clk_1") ? PLL_CLKIN_0_SRC_CLK_1 :
								   (pll_clkin_0_src_1 == "clk_2") ? PLL_CLKIN_0_SRC_CLK_2 :
								   (pll_clkin_0_src_1 == "clk_3") ? PLL_CLKIN_0_SRC_CLK_3 :
								   (pll_clkin_0_src_1 == "vss") ? PLL_CLKIN_0_SRC_VSS :
								   (pll_clkin_0_src_1 == "cmu_iqclk") ? PLL_CLKIN_0_SRC_CMU_IQCLK :
								   (pll_clkin_0_src_1 == "iqtxrxclk") ? PLL_CLKIN_0_SRC_IQTXRXCLK :
								   (pll_clkin_0_src_1 == "fpll") ? PLL_CLKIN_0_SRC_FPLL :
								   (pll_clkin_0_src_1 == "pll_iqclk") ? PLL_CLKIN_0_SRC_PLL_IQCLK : PLL_CLKIN_0_SRC_VSS;

								   
////////////////////////////////////////////////////////////////////////////////
// pll_clkin_1_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLKIN_1_SRC_PLL_IQCLK = 4'b1100 ;
localparam PLL_CLKIN_1_SRC_FPLL = 4'b1011 ;
localparam PLL_CLKIN_1_SRC_IQTXRXCLK = 4'b1010 ;
localparam PLL_CLKIN_1_SRC_CMU_IQCLK = 4'b1001 ;
localparam PLL_CLKIN_1_SRC_VSS = 4'b1000 ;
localparam PLL_CLKIN_1_SRC_CLK_3 = 4'b0111 ;
localparam PLL_CLKIN_1_SRC_CLK_2 = 4'b0110 ;
localparam PLL_CLKIN_1_SRC_CLK_1 = 4'b0101 ;
localparam PLL_CLKIN_1_SRC_CLK_0 = 4'b0100 ;
localparam PLL_CLKIN_1_SRC_REF_CLK1 = 4'b0011 ;
localparam PLL_CLKIN_1_SRC_REF_CLK0 = 4'b0010 ;
localparam PLL_CLKIN_1_SRC_ADJ_PLL_CLK = 4'b0001 ;
localparam PLL_CLKIN_1_SRC_CORE_REF_CLK = 4'b0000 ;
localparam local_pll_clkin_1_src_0 = (pll_clkin_1_src_0 == "core_ref_clk") ? PLL_CLKIN_1_SRC_CORE_REF_CLK :
								   (pll_clkin_1_src_0 == "adj_pll_clk") ? PLL_CLKIN_1_SRC_ADJ_PLL_CLK :
								   (pll_clkin_1_src_0 == "ref_clk0") ? PLL_CLKIN_1_SRC_REF_CLK0 :
								   (pll_clkin_1_src_0 == "ref_clk1") ? PLL_CLKIN_1_SRC_REF_CLK1 :
								   (pll_clkin_1_src_0 == "clk_0") ? PLL_CLKIN_1_SRC_CLK_0 :
								   (pll_clkin_1_src_0 == "clk_1") ? PLL_CLKIN_1_SRC_CLK_1 :
								   (pll_clkin_1_src_0 == "clk_2") ? PLL_CLKIN_1_SRC_CLK_2 :
								   (pll_clkin_1_src_0 == "clk_3") ? PLL_CLKIN_1_SRC_CLK_3 :
								   (pll_clkin_1_src_0 == "vss") ? PLL_CLKIN_1_SRC_VSS :
								   (pll_clkin_1_src_0 == "cmu_iqclk") ? PLL_CLKIN_1_SRC_CMU_IQCLK :
								   (pll_clkin_1_src_0 == "iqtxrxclk") ? PLL_CLKIN_1_SRC_IQTXRXCLK :
								   (pll_clkin_1_src_0 == "fpll") ? PLL_CLKIN_1_SRC_FPLL :
								   (pll_clkin_1_src_0 == "pll_iqclk") ? PLL_CLKIN_1_SRC_PLL_IQCLK : PLL_CLKIN_1_SRC_VSS;
localparam local_pll_clkin_1_src_1 = (pll_clkin_1_src_1 == "core_ref_clk") ? PLL_CLKIN_1_SRC_CORE_REF_CLK :
								   (pll_clkin_1_src_1 == "adj_pll_clk") ? PLL_CLKIN_1_SRC_ADJ_PLL_CLK :
								   (pll_clkin_1_src_1 == "ref_clk0") ? PLL_CLKIN_1_SRC_REF_CLK0 :
								   (pll_clkin_1_src_1 == "ref_clk1") ? PLL_CLKIN_1_SRC_REF_CLK1 :
								   (pll_clkin_1_src_1 == "clk_0") ? PLL_CLKIN_1_SRC_CLK_0 :
								   (pll_clkin_1_src_1 == "clk_1") ? PLL_CLKIN_1_SRC_CLK_1 :
								   (pll_clkin_1_src_1 == "clk_2") ? PLL_CLKIN_1_SRC_CLK_2 :
								   (pll_clkin_1_src_1 == "clk_3") ? PLL_CLKIN_1_SRC_CLK_3 :
								   (pll_clkin_1_src_1 == "vss") ? PLL_CLKIN_1_SRC_VSS :
								   (pll_clkin_1_src_1 == "cmu_iqclk") ? PLL_CLKIN_1_SRC_CMU_IQCLK :
								   (pll_clkin_1_src_1 == "iqtxrxclk") ? PLL_CLKIN_1_SRC_IQTXRXCLK :
								   (pll_clkin_1_src_1 == "fpll") ? PLL_CLKIN_1_SRC_FPLL :
								   (pll_clkin_1_src_1 == "pll_iqclk") ? PLL_CLKIN_1_SRC_PLL_IQCLK : PLL_CLKIN_1_SRC_VSS;
								   
////////////////////////////////////////////////////////////////////////////////
// pll_clk_sw_dly_setting
////////////////////////////////////////////////////////////////////////////////
localparam SWITCHOVER_DLY_SETTING = 3'b000 ;
localparam local_pll_clk_sw_dly_0 = pll_clk_sw_dly_0;
localparam local_pll_clk_sw_dly_1 = pll_clk_sw_dly_1;
localparam local_pll_clk_sw_dly_setting_0 = pll_clk_sw_dly_0;
localparam local_pll_clk_sw_dly_setting_1 = pll_clk_sw_dly_1;

////////////////////////////////////////////////////////////////////////////////
// pll_clk_loss_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLK_LOSS_SW_ENABLED = 1'b1 ;
localparam PLL_CLK_LOSS_SW_BYPS = 1'b0 ;
localparam local_pll_clk_loss_sw_en_0 = (pll_clk_loss_sw_en_0 == "false") ? PLL_CLK_LOSS_SW_BYPS : PLL_CLK_LOSS_SW_ENABLED;
localparam local_pll_clk_loss_sw_en_1 = (pll_clk_loss_sw_en_1 == "false") ? PLL_CLK_LOSS_SW_BYPS : PLL_CLK_LOSS_SW_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_manu_clk_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_MANU_CLK_SW_ENABLED = 1'b1 ;
localparam PLL_MANU_CLK_SW_DISABLED = 1'b0 ;
localparam local_pll_manu_clk_sw_en_0 = (pll_manu_clk_sw_en_0 == "false") ? PLL_MANU_CLK_SW_DISABLED : PLL_MANU_CLK_SW_ENABLED;
localparam local_pll_manu_clk_sw_en_1 = (pll_manu_clk_sw_en_1 == "false") ? PLL_MANU_CLK_SW_DISABLED : PLL_MANU_CLK_SW_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_auto_clk_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_AUTO_CLK_SW_ENABLED = 1'b1 ;
localparam PLL_AUTO_CLK_SW_DISABLED = 1'b0 ;
localparam local_pll_auto_clk_sw_en_0 = (pll_auto_clk_sw_en_0 == "false") ? PLL_AUTO_CLK_SW_DISABLED : PLL_AUTO_CLK_SW_ENABLED; ////////////////////////////////////////////////////////////////////////////////
localparam local_pll_auto_clk_sw_en_1 = (pll_auto_clk_sw_en_1 == "false") ? PLL_AUTO_CLK_SW_DISABLED : PLL_AUTO_CLK_SW_ENABLED; ////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph0_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH0_EN = 1'b1 ;
localparam PLL_VCO_PH0_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph0_en_0 = (pll_vco_ph0_en_0 == "false") ? PLL_VCO_PH0_DIS_EN : PLL_VCO_PH0_EN;
localparam local_pll_vco_ph0_en_1 = (pll_vco_ph0_en_1 == "false") ? PLL_VCO_PH0_DIS_EN : PLL_VCO_PH0_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph1_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH1_EN = 1'b1 ;
localparam PLL_VCO_PH1_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph1_en_0 = (pll_vco_ph1_en_0 == "false") ? PLL_VCO_PH1_DIS_EN : PLL_VCO_PH1_EN;
localparam local_pll_vco_ph1_en_1 = (pll_vco_ph1_en_1 == "false") ? PLL_VCO_PH1_DIS_EN : PLL_VCO_PH1_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph2_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH2_EN = 1'b1 ;
localparam PLL_VCO_PH2_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph2_en_0 = (pll_vco_ph2_en_0 == "false") ? PLL_VCO_PH2_DIS_EN : PLL_VCO_PH2_EN;
localparam local_pll_vco_ph2_en_1 = (pll_vco_ph2_en_1 == "false") ? PLL_VCO_PH2_DIS_EN : PLL_VCO_PH2_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph3_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH3_EN = 1'b1 ;
localparam PLL_VCO_PH3_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph3_en_0 = (pll_vco_ph3_en_0 == "false") ? PLL_VCO_PH3_DIS_EN : PLL_VCO_PH3_EN;
localparam local_pll_vco_ph3_en_1 = (pll_vco_ph3_en_1 == "false") ? PLL_VCO_PH3_DIS_EN : PLL_VCO_PH3_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph4_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH4_EN = 1'b1 ;
localparam PLL_VCO_PH4_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph4_en_0 = (pll_vco_ph4_en_0 == "false") ? PLL_VCO_PH4_DIS_EN : PLL_VCO_PH4_EN;
localparam local_pll_vco_ph4_en_1 = (pll_vco_ph4_en_1 == "false") ? PLL_VCO_PH4_DIS_EN : PLL_VCO_PH4_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph5_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH5_EN = 1'b1 ;
localparam PLL_VCO_PH5_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph5_en_0 = (pll_vco_ph5_en_0 == "false") ? PLL_VCO_PH5_DIS_EN : PLL_VCO_PH5_EN;
localparam local_pll_vco_ph5_en_1 = (pll_vco_ph5_en_1 == "false") ? PLL_VCO_PH5_DIS_EN : PLL_VCO_PH5_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph6_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH6_EN = 1'b1 ;
localparam PLL_VCO_PH6_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph6_en_0 = (pll_vco_ph6_en_0 == "false") ? PLL_VCO_PH6_DIS_EN : PLL_VCO_PH6_EN;
localparam local_pll_vco_ph6_en_1 = (pll_vco_ph6_en_1 == "false") ? PLL_VCO_PH6_DIS_EN : PLL_VCO_PH6_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph7_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH7_EN = 1'b1 ;
localparam PLL_VCO_PH7_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph7_en_0 = (pll_vco_ph7_en_0 == "false") ? PLL_VCO_PH7_DIS_EN : PLL_VCO_PH7_EN;
localparam local_pll_vco_ph7_en_1 = (pll_vco_ph7_en_1 == "false") ? PLL_VCO_PH7_DIS_EN : PLL_VCO_PH7_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_enable
////////////////////////////////////////////////////////////////////////////////
localparam PLL_ENABLED = 1'b1 ;
localparam PLL_DISABLED = 1'b0 ;
localparam local_pll_enable_0 = (pll_enable_0 == "true") ? PLL_ENABLED : PLL_DISABLED;
localparam local_pll_enable_1 = (pll_enable_1 == "true") ? PLL_ENABLED : PLL_DISABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_ctrl_override_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CTRL_ENABLE = 1'b1 ;
localparam PLL_CTRL_DISABLE = 1'b0 ;
localparam local_pll_ctrl_override_setting_0 = (pll_ctrl_override_setting_0 == "false") ? PLL_CTRL_DISABLE : PLL_CTRL_ENABLE;
localparam local_pll_ctrl_override_setting_1 = (pll_ctrl_override_setting_1 == "false") ? PLL_CTRL_DISABLE : PLL_CTRL_ENABLE;

////////////////////////////////////////////////////////////////////////////////
// pll_fbclk_mux_1
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FBCLK_MUX_1_FBCLK_FPLL = 2'b11 ;
localparam PLL_FBCLK_MUX_1_LVDS = 2'b10 ;
localparam PLL_FBCLK_MUX_1_ZBD = 2'b01 ;
localparam PLL_FBCLK_MUX_1_GLB = 2'b00 ;
localparam local_pll_fbclk_mux_1_0 = (pll_fbclk_mux_1_0 == "glb") ? PLL_FBCLK_MUX_1_GLB :
								   (pll_fbclk_mux_1_0 == "zbd") ? PLL_FBCLK_MUX_1_ZBD :
								   (pll_fbclk_mux_1_0 == "lvds") ? PLL_FBCLK_MUX_1_LVDS : PLL_FBCLK_MUX_1_FBCLK_FPLL;
localparam local_pll_fbclk_mux_1_1 = (pll_fbclk_mux_1_1 == "glb") ? PLL_FBCLK_MUX_1_GLB :
								   (pll_fbclk_mux_1_1 == "zbd") ? PLL_FBCLK_MUX_1_ZBD :
								   (pll_fbclk_mux_1_1 == "lvds") ? PLL_FBCLK_MUX_1_LVDS : PLL_FBCLK_MUX_1_FBCLK_FPLL;

////////////////////////////////////////////////////////////////////////////////
// pll_fbclk_mux_2
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FBCLK_MUX_2_M_CNT = 1'b1 ;
localparam PLL_FBCLK_MUX_2_FB_1 = 1'b0 ;
localparam local_pll_fbclk_mux_2_0 = (pll_fbclk_mux_2_0 == "fb_1") ? PLL_FBCLK_MUX_2_FB_1 : PLL_FBCLK_MUX_2_M_CNT;
localparam local_pll_fbclk_mux_2_1 = (pll_fbclk_mux_2_1 == "fb_1") ? PLL_FBCLK_MUX_2_FB_1 : PLL_FBCLK_MUX_2_M_CNT;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_BYPASS_ENABLED = 1'b1 ;
localparam PLL_N_CNT_DIV_ENABLED = 1'b0 ;
localparam local_pll_n_cnt_bypass_en_0 = (pll_n_cnt_bypass_en_0 == "false") ? PLL_N_CNT_DIV_ENABLED : PLL_N_CNT_BYPASS_ENABLED;
localparam local_pll_n_cnt_bypass_en_1 = (pll_n_cnt_bypass_en_1 == "false") ? PLL_N_CNT_DIV_ENABLED : PLL_N_CNT_BYPASS_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_lo_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_LO_VALUE = 8'h01 ;
localparam local_pll_n_cnt_lo_div_0 = pll_n_cnt_lo_div_0;
localparam local_pll_n_cnt_lo_div_setting_0 = pll_n_cnt_lo_div_0;
localparam local_pll_n_cnt_lo_div_1 = pll_n_cnt_lo_div_1;
localparam local_pll_n_cnt_lo_div_setting_1 = pll_n_cnt_lo_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_hi_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_HI_VALUE = 8'h01 ;
localparam local_pll_n_cnt_hi_div_0 = pll_n_cnt_hi_div_0;
localparam local_pll_n_cnt_hi_div_setting_0 = pll_n_cnt_hi_div_0;
localparam local_pll_n_cnt_hi_div_1 = pll_n_cnt_hi_div_1;
localparam local_pll_n_cnt_hi_div_setting_1 = pll_n_cnt_hi_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_odd_div_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_EVEN_DUTY_ENABLED = 1'b1 ;
localparam PLL_N_CNT_EVEN_DUTY_DISABLED = 1'b0 ;
localparam local_pll_n_cnt_odd_div_duty_en_0 = (pll_n_cnt_odd_div_duty_en_0 == "false") ? PLL_N_CNT_EVEN_DUTY_DISABLED : PLL_N_CNT_EVEN_DUTY_ENABLED;
localparam local_pll_n_cnt_odd_div_duty_en_1 = (pll_n_cnt_odd_div_duty_en_1 == "false") ? PLL_N_CNT_EVEN_DUTY_DISABLED : PLL_N_CNT_EVEN_DUTY_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_tclk_sel
////////////////////////////////////////////////////////////////////////////////
localparam PLL_TCLK_M_SRC = 1'b1 ;
localparam PLL_TCLK_N_SRC = 1'b0 ;
localparam local_pll_tclk_sel_0 = (pll_tclk_sel_0 == "cdb_pll_tclk_sel_m_src") ? PLL_TCLK_M_SRC : PLL_TCLK_N_SRC;
localparam local_pll_tclk_sel_1 = (pll_tclk_sel_1 == "cdb_pll_tclk_sel_m_src") ? PLL_TCLK_M_SRC : PLL_TCLK_N_SRC;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_odd_div_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_EVEN_DUTY_ENABLED = 1'b1 ;
localparam PLL_M_CNT_EVEN_DUTY_DISABLED = 1'b0 ;
localparam local_pll_m_cnt_odd_div_duty_en_0 = (pll_m_cnt_odd_div_duty_en_0 == "false") ? PLL_M_CNT_EVEN_DUTY_DISABLED : PLL_M_CNT_EVEN_DUTY_ENABLED;
localparam local_pll_m_cnt_odd_div_duty_en_1 = (pll_m_cnt_odd_div_duty_en_1 == "false") ? PLL_M_CNT_EVEN_DUTY_DISABLED : PLL_M_CNT_EVEN_DUTY_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_BYPASS_ENABLED = 1'b1 ;
localparam PLL_M_CNT_DIV_ENABLED = 1'b0 ;
localparam local_pll_m_cnt_bypass_en_0 = (pll_m_cnt_bypass_en_0 == "false") ? PLL_M_CNT_DIV_ENABLED : PLL_M_CNT_BYPASS_ENABLED;
localparam local_pll_m_cnt_bypass_en_1 = (pll_m_cnt_bypass_en_1 == "false") ? PLL_M_CNT_DIV_ENABLED : PLL_M_CNT_BYPASS_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_hi_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_HI_VALUE = 8'h01 ;
localparam local_pll_m_cnt_hi_div_0 = pll_m_cnt_hi_div_0;
localparam local_pll_m_cnt_hi_div_setting_0 = pll_m_cnt_hi_div_0;
localparam local_pll_m_cnt_hi_div_1 = pll_m_cnt_hi_div_1;
localparam local_pll_m_cnt_hi_div_setting_1 = pll_m_cnt_hi_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_in_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_IN_SRC_VSS = 2'b11 ;
localparam PLL_M_CNT_IN_SRC_TEST_CLK = 2'b10 ;
localparam PLL_M_CNT_IN_SRC_FBLVDS = 2'b01 ;
localparam PLL_M_CNT_IN_SRC_PH_MUX_CLK = 2'b00 ;
localparam local_pll_m_cnt_in_src_0 = (pll_m_cnt_in_src_0 == "ph_mux_clk") ? PLL_M_CNT_IN_SRC_PH_MUX_CLK :
									(pll_m_cnt_in_src_0 == "fblvds") ? PLL_M_CNT_IN_SRC_FBLVDS :
									(pll_m_cnt_in_src_0 == "test_clk") ? PLL_M_CNT_IN_SRC_TEST_CLK : PLL_M_CNT_IN_SRC_VSS;
localparam local_pll_m_cnt_in_src_1 = (pll_m_cnt_in_src_1 == "ph_mux_clk") ? PLL_M_CNT_IN_SRC_PH_MUX_CLK :
									(pll_m_cnt_in_src_1 == "fblvds") ? PLL_M_CNT_IN_SRC_FBLVDS :
									(pll_m_cnt_in_src_1 == "test_clk") ? PLL_M_CNT_IN_SRC_TEST_CLK : PLL_M_CNT_IN_SRC_VSS;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_lo_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_LO_VALUE = 8'h01 ;
localparam local_pll_m_cnt_lo_div_0 = pll_m_cnt_lo_div_0;
localparam local_pll_m_cnt_lo_div_setting_0 = pll_m_cnt_lo_div_0;
localparam local_pll_m_cnt_lo_div_1 = pll_m_cnt_lo_div_1;
localparam local_pll_m_cnt_lo_div_setting_1 = pll_m_cnt_lo_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_prst_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_PRST_VALUE = 8'h01 ;
localparam local_pll_m_cnt_prst_0 = pll_m_cnt_prst_0;
localparam local_pll_m_cnt_prst_setting_0 = pll_m_cnt_prst_0;
localparam local_pll_m_cnt_prst_1 = pll_m_cnt_prst_1;
localparam local_pll_m_cnt_prst_setting_1 = pll_m_cnt_prst_1;

////////////////////////////////////////////////////////////////////////////////
// pll_unlock_fltr_cfg_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_UNLOCK_COUNTER_SETTING = 3'b000 ;
localparam local_pll_unlock_fltr_cfg_0 = pll_unlock_fltr_cfg_0;
localparam local_pll_unlock_fltr_cfg_setting_0 = pll_unlock_fltr_cfg_0;
localparam local_pll_unlock_fltr_cfg_1 = pll_unlock_fltr_cfg_1;
localparam local_pll_unlock_fltr_cfg_setting_1 = pll_unlock_fltr_cfg_1;

////////////////////////////////////////////////////////////////////////////////
// pll_lock_fltr_cfg_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_LOCK_COUNTER_SETTING = 12'h001 ;
localparam local_pll_lock_fltr_cfg_0 = pll_lock_fltr_cfg_0;
localparam local_pll_lock_fltr_cfg_setting_0 = pll_lock_fltr_cfg_0;
localparam local_pll_lock_fltr_cfg_1 = pll_lock_fltr_cfg_1;
localparam local_pll_lock_fltr_cfg_setting_1 = pll_lock_fltr_cfg_1;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_in_src
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_IN_SRC_TEST_CLK1 = 2'b11 ;
localparam C_CNT_IN_SRC_TEST_CLK0 = 2'b10 ;
localparam C_CNT_IN_SRC_CSCD_CLK = 2'b01 ;
localparam C_CNT_IN_SRC_PH_MUX_CLK = 2'b00 ;
localparam local_c_cnt_in_src_0 = (c_cnt_in_src_0 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_0 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_0 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_1 = (c_cnt_in_src_1 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_1 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_1 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_2 = (c_cnt_in_src_2 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_2 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_2 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_3 = (c_cnt_in_src_3 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_3 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_3 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_4 = (c_cnt_in_src_4 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_4 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_4 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_5 = (c_cnt_in_src_5 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_5 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_5 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_6 = (c_cnt_in_src_6 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_6 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_6 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_7 = (c_cnt_in_src_7 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_7 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_7 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_8 = (c_cnt_in_src_8 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_8 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_8 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_9 = (c_cnt_in_src_9 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_9 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_9 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_10 = (c_cnt_in_src_10 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_10 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_10 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_11 = (c_cnt_in_src_11 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_11 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_11 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_12 = (c_cnt_in_src_12 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_12 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_12 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_13 = (c_cnt_in_src_13 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_13 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_13 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_14 = (c_cnt_in_src_14 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_14 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_14 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_15 = (c_cnt_in_src_15 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_15 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_15 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_16 = (c_cnt_in_src_16 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_16 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_16 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_17 = (c_cnt_in_src_17 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_17 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_17 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;

////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_DIV_ENABLED = 0 ;
localparam local_dprio0_cnt_bypass_en_0 = (dprio0_cnt_bypass_en_0 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_0 = (dprio0_cnt_bypass_en_0 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_1 = (dprio0_cnt_bypass_en_1 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_1 = (dprio0_cnt_bypass_en_1 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_2 = (dprio0_cnt_bypass_en_2 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_2 = (dprio0_cnt_bypass_en_2 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_3 = (dprio0_cnt_bypass_en_3 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_3 = (dprio0_cnt_bypass_en_3 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_4 = (dprio0_cnt_bypass_en_4 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_4 = (dprio0_cnt_bypass_en_4 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_5 = (dprio0_cnt_bypass_en_5 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_5 = (dprio0_cnt_bypass_en_5 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_6 = (dprio0_cnt_bypass_en_6 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_6 = (dprio0_cnt_bypass_en_6 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_7 = (dprio0_cnt_bypass_en_7 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_7 = (dprio0_cnt_bypass_en_7 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_8 = (dprio0_cnt_bypass_en_8 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_8 = (dprio0_cnt_bypass_en_8 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_9 = (dprio0_cnt_bypass_en_9 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_9 = (dprio0_cnt_bypass_en_9 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_10 = (dprio0_cnt_bypass_en_10 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_10 = (dprio0_cnt_bypass_en_10 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_11 = (dprio0_cnt_bypass_en_11 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_11 = (dprio0_cnt_bypass_en_11 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_12 = (dprio0_cnt_bypass_en_12 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_12 = (dprio0_cnt_bypass_en_12 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_13 = (dprio0_cnt_bypass_en_13 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_13 = (dprio0_cnt_bypass_en_13 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_14 = (dprio0_cnt_bypass_en_14 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_14 = (dprio0_cnt_bypass_en_14 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_15 = (dprio0_cnt_bypass_en_15 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_15 = (dprio0_cnt_bypass_en_15 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_16 = (dprio0_cnt_bypass_en_16 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_16 = (dprio0_cnt_bypass_en_16 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_17 = (dprio0_cnt_bypass_en_17 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_17 = (dprio0_cnt_bypass_en_17 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_prst
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_PRST_VALUE = 1 ;
localparam local_c_cnt_prst_0 = c_cnt_prst_0;
localparam local_c_cnt_prst_user_0 = c_cnt_prst_0;
localparam local_c_cnt_prst_1 = c_cnt_prst_1;
localparam local_c_cnt_prst_user_1 = c_cnt_prst_1;
localparam local_c_cnt_prst_2 = c_cnt_prst_2;
localparam local_c_cnt_prst_user_2 = c_cnt_prst_2;
localparam local_c_cnt_prst_3 = c_cnt_prst_3;
localparam local_c_cnt_prst_user_3 = c_cnt_prst_3;
localparam local_c_cnt_prst_4 = c_cnt_prst_4;
localparam local_c_cnt_prst_user_4 = c_cnt_prst_4;
localparam local_c_cnt_prst_5 = c_cnt_prst_5;
localparam local_c_cnt_prst_user_5 = c_cnt_prst_5;
localparam local_c_cnt_prst_6 = c_cnt_prst_6;
localparam local_c_cnt_prst_user_6 = c_cnt_prst_6;
localparam local_c_cnt_prst_7 = c_cnt_prst_7;
localparam local_c_cnt_prst_user_7 = c_cnt_prst_7;
localparam local_c_cnt_prst_8 = c_cnt_prst_8;
localparam local_c_cnt_prst_user_8 = c_cnt_prst_8;
localparam local_c_cnt_prst_9 = c_cnt_prst_9;
localparam local_c_cnt_prst_user_9 = c_cnt_prst_9;
localparam local_c_cnt_prst_10 = c_cnt_prst_10;
localparam local_c_cnt_prst_user_10 = c_cnt_prst_10;
localparam local_c_cnt_prst_11 = c_cnt_prst_11;
localparam local_c_cnt_prst_user_11 = c_cnt_prst_11;
localparam local_c_cnt_prst_12 = c_cnt_prst_12;
localparam local_c_cnt_prst_user_12 = c_cnt_prst_12;
localparam local_c_cnt_prst_13 = c_cnt_prst_13;
localparam local_c_cnt_prst_user_13 = c_cnt_prst_13;
localparam local_c_cnt_prst_14 = c_cnt_prst_14;
localparam local_c_cnt_prst_user_14 = c_cnt_prst_14;
localparam local_c_cnt_prst_15 = c_cnt_prst_15;
localparam local_c_cnt_prst_user_15 = c_cnt_prst_15;
localparam local_c_cnt_prst_16 = c_cnt_prst_16;
localparam local_c_cnt_prst_user_16 = c_cnt_prst_16;
localparam local_c_cnt_prst_17 = c_cnt_prst_17;
localparam local_c_cnt_prst_user_17 = c_cnt_prst_17;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_ph_mux_prst
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_PH_MUX_PRST_VALUE = 0 ;
localparam local_c_cnt_ph_mux_prst_0 = c_cnt_ph_mux_prst_0;
localparam local_c_cnt_ph_mux_prst_user_0 = c_cnt_ph_mux_prst_0;
localparam local_c_cnt_ph_mux_prst_1 = c_cnt_ph_mux_prst_1;
localparam local_c_cnt_ph_mux_prst_user_1 = c_cnt_ph_mux_prst_1;
localparam local_c_cnt_ph_mux_prst_2 = c_cnt_ph_mux_prst_2;
localparam local_c_cnt_ph_mux_prst_user_2 = c_cnt_ph_mux_prst_2;
localparam local_c_cnt_ph_mux_prst_3 = c_cnt_ph_mux_prst_3;
localparam local_c_cnt_ph_mux_prst_user_3 = c_cnt_ph_mux_prst_3;
localparam local_c_cnt_ph_mux_prst_4 = c_cnt_ph_mux_prst_4;
localparam local_c_cnt_ph_mux_prst_user_4 = c_cnt_ph_mux_prst_4;
localparam local_c_cnt_ph_mux_prst_5 = c_cnt_ph_mux_prst_5;
localparam local_c_cnt_ph_mux_prst_user_5 = c_cnt_ph_mux_prst_5;
localparam local_c_cnt_ph_mux_prst_6 = c_cnt_ph_mux_prst_6;
localparam local_c_cnt_ph_mux_prst_user_6 = c_cnt_ph_mux_prst_6;
localparam local_c_cnt_ph_mux_prst_7 = c_cnt_ph_mux_prst_7;
localparam local_c_cnt_ph_mux_prst_user_7 = c_cnt_ph_mux_prst_7;
localparam local_c_cnt_ph_mux_prst_8 = c_cnt_ph_mux_prst_8;
localparam local_c_cnt_ph_mux_prst_user_8 = c_cnt_ph_mux_prst_8;
localparam local_c_cnt_ph_mux_prst_9 = c_cnt_ph_mux_prst_9;
localparam local_c_cnt_ph_mux_prst_user_9 = c_cnt_ph_mux_prst_9;
localparam local_c_cnt_ph_mux_prst_10 = c_cnt_ph_mux_prst_10;
localparam local_c_cnt_ph_mux_prst_user_10 = c_cnt_ph_mux_prst_10;
localparam local_c_cnt_ph_mux_prst_11 = c_cnt_ph_mux_prst_11;
localparam local_c_cnt_ph_mux_prst_user_11 = c_cnt_ph_mux_prst_11;
localparam local_c_cnt_ph_mux_prst_12 = c_cnt_ph_mux_prst_12;
localparam local_c_cnt_ph_mux_prst_user_12 = c_cnt_ph_mux_prst_12;
localparam local_c_cnt_ph_mux_prst_13 = c_cnt_ph_mux_prst_13;
localparam local_c_cnt_ph_mux_prst_user_13 = c_cnt_ph_mux_prst_13;
localparam local_c_cnt_ph_mux_prst_14 = c_cnt_ph_mux_prst_14;
localparam local_c_cnt_ph_mux_prst_user_14 = c_cnt_ph_mux_prst_14;
localparam local_c_cnt_ph_mux_prst_15 = c_cnt_ph_mux_prst_15;
localparam local_c_cnt_ph_mux_prst_user_15 = c_cnt_ph_mux_prst_15;
localparam local_c_cnt_ph_mux_prst_16 = c_cnt_ph_mux_prst_16;
localparam local_c_cnt_ph_mux_prst_user_16 = c_cnt_ph_mux_prst_16;
localparam local_c_cnt_ph_mux_prst_17 = c_cnt_ph_mux_prst_17;
localparam local_c_cnt_ph_mux_prst_user_17 = c_cnt_ph_mux_prst_17;

/////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_hi_div
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_HI_DIV_VALUE = 0 ;
localparam local_dprio0_cnt_hi_div_0 = dprio0_cnt_hi_div_0;
localparam local_dprio0_cnt_hi_div_user_0 = dprio0_cnt_hi_div_0;
localparam local_dprio0_cnt_hi_div_1 = dprio0_cnt_hi_div_1;
localparam local_dprio0_cnt_hi_div_user_1 = dprio0_cnt_hi_div_1;
localparam local_dprio0_cnt_hi_div_2 = dprio0_cnt_hi_div_2;
localparam local_dprio0_cnt_hi_div_user_2 = dprio0_cnt_hi_div_2;
localparam local_dprio0_cnt_hi_div_3 = dprio0_cnt_hi_div_3;
localparam local_dprio0_cnt_hi_div_user_3 = dprio0_cnt_hi_div_3;
localparam local_dprio0_cnt_hi_div_4 = dprio0_cnt_hi_div_4;
localparam local_dprio0_cnt_hi_div_user_4 = dprio0_cnt_hi_div_4;
localparam local_dprio0_cnt_hi_div_5 = dprio0_cnt_hi_div_5;
localparam local_dprio0_cnt_hi_div_user_5 = dprio0_cnt_hi_div_5;
localparam local_dprio0_cnt_hi_div_6 = dprio0_cnt_hi_div_6;
localparam local_dprio0_cnt_hi_div_user_6 = dprio0_cnt_hi_div_6;
localparam local_dprio0_cnt_hi_div_7 = dprio0_cnt_hi_div_7;
localparam local_dprio0_cnt_hi_div_user_7 = dprio0_cnt_hi_div_7;
localparam local_dprio0_cnt_hi_div_8 = dprio0_cnt_hi_div_8;
localparam local_dprio0_cnt_hi_div_user_8 = dprio0_cnt_hi_div_8;
localparam local_dprio0_cnt_hi_div_9 = dprio0_cnt_hi_div_9;
localparam local_dprio0_cnt_hi_div_user_9 = dprio0_cnt_hi_div_9;
localparam local_dprio0_cnt_hi_div_10 = dprio0_cnt_hi_div_10;
localparam local_dprio0_cnt_hi_div_user_10 = dprio0_cnt_hi_div_10;
localparam local_dprio0_cnt_hi_div_11 = dprio0_cnt_hi_div_11;
localparam local_dprio0_cnt_hi_div_user_11 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_12 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_user_12 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_13 = dprio0_cnt_hi_div_13;
localparam local_dprio0_cnt_hi_div_user_13 = dprio0_cnt_hi_div_13;
localparam local_dprio0_cnt_hi_div_14 = dprio0_cnt_hi_div_14;
localparam local_dprio0_cnt_hi_div_user_14 = dprio0_cnt_hi_div_14;
localparam local_dprio0_cnt_hi_div_15 = dprio0_cnt_hi_div_15;
localparam local_dprio0_cnt_hi_div_user_15 = dprio0_cnt_hi_div_15;
localparam local_dprio0_cnt_hi_div_16 = dprio0_cnt_hi_div_16;
localparam local_dprio0_cnt_hi_div_user_16 = dprio0_cnt_hi_div_16;
localparam local_dprio0_cnt_hi_div_17 = dprio0_cnt_hi_div_17;
localparam local_dprio0_cnt_hi_div_user_17 = dprio0_cnt_hi_div_17;

///////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_lo_div
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_LO_DIV_VALUE = 0 ;
localparam local_dprio0_cnt_lo_div_0 = dprio0_cnt_lo_div_0;
localparam local_dprio0_cnt_lo_div_user_0 = dprio0_cnt_lo_div_0;
localparam local_dprio0_cnt_lo_div_1 = dprio0_cnt_lo_div_1;
localparam local_dprio0_cnt_lo_div_user_1 = dprio0_cnt_lo_div_1;
localparam local_dprio0_cnt_lo_div_2 = dprio0_cnt_lo_div_2;
localparam local_dprio0_cnt_lo_div_user_2 = dprio0_cnt_lo_div_2;
localparam local_dprio0_cnt_lo_div_3 = dprio0_cnt_lo_div_3;
localparam local_dprio0_cnt_lo_div_user_3 = dprio0_cnt_lo_div_3;
localparam local_dprio0_cnt_lo_div_4 = dprio0_cnt_lo_div_4;
localparam local_dprio0_cnt_lo_div_user_4 = dprio0_cnt_lo_div_4;
localparam local_dprio0_cnt_lo_div_5 = dprio0_cnt_lo_div_5;
localparam local_dprio0_cnt_lo_div_user_5 = dprio0_cnt_lo_div_5;
localparam local_dprio0_cnt_lo_div_6 = dprio0_cnt_lo_div_6;
localparam local_dprio0_cnt_lo_div_user_6 = dprio0_cnt_lo_div_6;
localparam local_dprio0_cnt_lo_div_7 = dprio0_cnt_lo_div_7;
localparam local_dprio0_cnt_lo_div_user_7 = dprio0_cnt_lo_div_7;
localparam local_dprio0_cnt_lo_div_8 = dprio0_cnt_lo_div_8;
localparam local_dprio0_cnt_lo_div_user_8 = dprio0_cnt_lo_div_8;
localparam local_dprio0_cnt_lo_div_9 = dprio0_cnt_lo_div_9;
localparam local_dprio0_cnt_lo_div_user_9 = dprio0_cnt_lo_div_9;
localparam local_dprio0_cnt_lo_div_10 = dprio0_cnt_lo_div_10;
localparam local_dprio0_cnt_lo_div_user_10 = dprio0_cnt_lo_div_10;
localparam local_dprio0_cnt_lo_div_11 = dprio0_cnt_lo_div_11;
localparam local_dprio0_cnt_lo_div_user_11 = dprio0_cnt_lo_div_11;
localparam local_dprio0_cnt_lo_div_12 = dprio0_cnt_lo_div_12;
localparam local_dprio0_cnt_lo_div_user_12 = dprio0_cnt_lo_div_12;
localparam local_dprio0_cnt_lo_div_13 = dprio0_cnt_lo_div_13;
localparam local_dprio0_cnt_lo_div_user_13 = dprio0_cnt_lo_div_13;
localparam local_dprio0_cnt_lo_div_14 = dprio0_cnt_lo_div_14;
localparam local_dprio0_cnt_lo_div_user_14 = dprio0_cnt_lo_div_14;
localparam local_dprio0_cnt_lo_div_15 = dprio0_cnt_lo_div_15;
localparam local_dprio0_cnt_lo_div_user_15 = dprio0_cnt_lo_div_15;
localparam local_dprio0_cnt_lo_div_16 = dprio0_cnt_lo_div_16;
localparam local_dprio0_cnt_lo_div_user_16 = dprio0_cnt_lo_div_16;
localparam local_dprio0_cnt_lo_div_17 = dprio0_cnt_lo_div_17;
localparam local_dprio0_cnt_lo_div_user_17 = dprio0_cnt_lo_div_17;

////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_odd_div_even_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED = 0 ;
localparam local_dprio0_cnt_odd_div_even_duty_en_0 = (dprio0_cnt_odd_div_even_duty_en_0 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_0 = (dprio0_cnt_odd_div_even_duty_en_0 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_1 = (dprio0_cnt_odd_div_even_duty_en_1 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_1 = (dprio0_cnt_odd_div_even_duty_en_1 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_2 = (dprio0_cnt_odd_div_even_duty_en_2 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_2 = (dprio0_cnt_odd_div_even_duty_en_2 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_3 = (dprio0_cnt_odd_div_even_duty_en_3 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_3 = (dprio0_cnt_odd_div_even_duty_en_3 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_4 = (dprio0_cnt_odd_div_even_duty_en_4 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_4 = (dprio0_cnt_odd_div_even_duty_en_4 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_5 = (dprio0_cnt_odd_div_even_duty_en_5 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_5 = (dprio0_cnt_odd_div_even_duty_en_5 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_6 = (dprio0_cnt_odd_div_even_duty_en_6 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_6 = (dprio0_cnt_odd_div_even_duty_en_6 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_7 = (dprio0_cnt_odd_div_even_duty_en_7 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_7 = (dprio0_cnt_odd_div_even_duty_en_7 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_8 = (dprio0_cnt_odd_div_even_duty_en_8 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_8 = (dprio0_cnt_odd_div_even_duty_en_8 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_9 = (dprio0_cnt_odd_div_even_duty_en_9 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_9 = (dprio0_cnt_odd_div_even_duty_en_9 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_10 = (dprio0_cnt_odd_div_even_duty_en_10 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_10 = (dprio0_cnt_odd_div_even_duty_en_10 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_11 = (dprio0_cnt_odd_div_even_duty_en_11 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_11 = (dprio0_cnt_odd_div_even_duty_en_11 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_12 = (dprio0_cnt_odd_div_even_duty_en_12 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_12 = (dprio0_cnt_odd_div_even_duty_en_12 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_13 = (dprio0_cnt_odd_div_even_duty_en_13 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_13 = (dprio0_cnt_odd_div_even_duty_en_13 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_14 = (dprio0_cnt_odd_div_even_duty_en_14 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_14 = (dprio0_cnt_odd_div_even_duty_en_14 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_15 = (dprio0_cnt_odd_div_even_duty_en_15 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_15 = (dprio0_cnt_odd_div_even_duty_en_15 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_16 = (dprio0_cnt_odd_div_even_duty_en_16 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_16 = (dprio0_cnt_odd_div_even_duty_en_16 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_17 = (dprio0_cnt_odd_div_even_duty_en_17 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_17 = (dprio0_cnt_odd_div_even_duty_en_17 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;



////////////////////////////////////////////////////////////////////////////////
// pll_bwctrl
////////////////////////////////////////////////////////////////////////////////
localparam PLL_BW_RES_UNUSED5 = 4'b1111 ;
localparam PLL_BW_RES_UNUSED4 = 4'b1110 ;
localparam PLL_BW_RES_UNUSED3 = 4'b1101 ;
localparam PLL_BW_RES_UNUSED2 = 4'b1100 ;
localparam PLL_BW_RES_UNUSED1 = 4'b1011 ;
localparam PLL_BW_RES_0P5K = 4'b1010 ;
localparam PLL_BW_RES_1K = 4'b1001 ;
localparam PLL_BW_RES_2K = 4'b1000 ;
localparam PLL_BW_RES_4K = 4'b0111 ;
localparam PLL_BW_RES_6K = 4'b0110 ;
localparam PLL_BW_RES_8K = 4'b0101 ;
localparam PLL_BW_RES_10K = 4'b0100 ;
localparam PLL_BW_RES_12K = 4'b0011 ;
localparam PLL_BW_RES_14K = 4'b0010 ;
localparam PLL_BW_RES_16K = 4'b0001 ;
localparam PLL_BW_RES_18K = 4'b0000 ;
localparam local_pll_bwctrl_0 = (pll_bwctrl_0 == 18000) ? PLL_BW_RES_18K :
							  (pll_bwctrl_0 == 16000) ? PLL_BW_RES_16K :
							  (pll_bwctrl_0 == 14000) ? PLL_BW_RES_14K :
							  (pll_bwctrl_0 == 12000) ? PLL_BW_RES_12K :
							  (pll_bwctrl_0 == 10000) ? PLL_BW_RES_10K :
							  (pll_bwctrl_0 == 8000) ? PLL_BW_RES_8K :
							  (pll_bwctrl_0 == 6000) ? PLL_BW_RES_6K :
							  (pll_bwctrl_0 == 4000) ? PLL_BW_RES_4K :
							  (pll_bwctrl_0 == 2000) ? PLL_BW_RES_2K :
							  (pll_bwctrl_0 == 1000) ? PLL_BW_RES_1K : 
							  (pll_bwctrl_0 == 500) ? PLL_BW_RES_0P5K : PLL_BW_RES_UNUSED1;
localparam local_pll_bwctrl_1 = (pll_bwctrl_1 == 18000) ? PLL_BW_RES_18K :
							  (pll_bwctrl_1 == 16000) ? PLL_BW_RES_16K :
							  (pll_bwctrl_1 == 14000) ? PLL_BW_RES_14K :
							  (pll_bwctrl_1 == 12000) ? PLL_BW_RES_12K :
							  (pll_bwctrl_1 == 10000) ? PLL_BW_RES_10K :
							  (pll_bwctrl_1 == 8000) ? PLL_BW_RES_8K :
							  (pll_bwctrl_1 == 6000) ? PLL_BW_RES_6K :
							  (pll_bwctrl_1 == 4000) ? PLL_BW_RES_4K :
							  (pll_bwctrl_1 == 2000) ? PLL_BW_RES_2K :
							  (pll_bwctrl_1 == 1000) ? PLL_BW_RES_1K : 
							  (pll_bwctrl_1 == 500) ? PLL_BW_RES_0P5K : PLL_BW_RES_UNUSED1;

////////////////////////////////////////////////////////////////////////////////
// pll_cp_current
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CP_UNUSED3 = 3'b111 ;
localparam PLL_CP_UNUSED2 = 3'b110 ;
localparam PLL_CP_UNUSED1 = 3'b101 ;
localparam PLL_CP_40UA = 3'b100 ;
localparam PLL_CP_30UA = 3'b011 ;
localparam PLL_CP_20UA = 3'b010 ;
localparam PLL_CP_10UA = 3'b001 ;
localparam PLL_CP_5UA = 3'b000 ;
localparam local_pll_cp_current_0 = (pll_cp_current_0 == 5) ? PLL_CP_5UA :
								  (pll_cp_current_0 == 10) ? PLL_CP_10UA :
								  (pll_cp_current_0 == 20) ? PLL_CP_20UA :
								  (pll_cp_current_0 == 30) ? PLL_CP_30UA :
								  (pll_cp_current_0 == 40) ? PLL_CP_40UA : PLL_CP_UNUSED1;
localparam local_pll_cp_current_1 = (pll_cp_current_1 == 5) ? PLL_CP_5UA :
								  (pll_cp_current_1 == 10) ? PLL_CP_10UA :
								  (pll_cp_current_1 == 20) ? PLL_CP_20UA :
								  (pll_cp_current_1 == 30) ? PLL_CP_30UA :
								  (pll_cp_current_1 == 40) ? PLL_CP_40UA : PLL_CP_UNUSED1;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_div
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_DIV_1300 = 1'b1 ;
localparam PLL_VCO_DIV_600 = 1'b0 ;
localparam local_pll_vco_div_0 = (pll_vco_div_0 == 1) ? PLL_VCO_DIV_600 : PLL_VCO_DIV_1300;
localparam local_pll_vco_div_1 = (pll_vco_div_1 == 1) ? PLL_VCO_DIV_600 : PLL_VCO_DIV_1300;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_division_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FRACTIONAL_DIVIDE_VALUE = 32'h00000000 ;
localparam local_pll_fractional_division_0 = pll_fractional_division_0;
localparam local_pll_fractional_division_setting_0 = pll_fractional_division_0;
localparam local_pll_fractional_division_1 = pll_fractional_division_1;
localparam local_pll_fractional_division_setting_1 = pll_fractional_division_1;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_value_ready
////////////////////////////////////////////////////////////////////////////////
localparam PLL_K_READY = 1'b1 ;
localparam PLL_K_NOT_READY = 1'b0 ;
localparam local_pll_fractional_value_ready_0 = (pll_fractional_value_ready_0 == "true") ? PLL_K_READY : PLL_K_NOT_READY;
localparam local_pll_fractional_value_ready_1 = (pll_fractional_value_ready_1 == "true") ? PLL_K_READY : PLL_K_NOT_READY;

////////////////////////////////////////////////////////////////////////////////
// pll_dsm_out_sel
////////////////////////////////////////////////////////////////////////////////
localparam PLL_DSM_3RD_ORDER = 2'b11 ;
localparam PLL_DSM_2ND_ORDER = 2'b10 ;
localparam PLL_DSM_1ST_ORDER = 2'b01 ;
localparam PLL_DSM_DISABLE = 2'b00 ;
localparam local_pll_dsm_out_sel_0 = (pll_dsm_out_sel_0 == "disable") ? PLL_DSM_DISABLE :
								   (pll_dsm_out_sel_0 == "1st_order") ? PLL_DSM_1ST_ORDER :
								   (pll_dsm_out_sel_0 == "2nd_order") ? PLL_DSM_2ND_ORDER : PLL_DSM_3RD_ORDER;
localparam local_pll_dsm_out_sel_1 = (pll_dsm_out_sel_1 == "disable") ? PLL_DSM_DISABLE :
								   (pll_dsm_out_sel_1 == "1st_order") ? PLL_DSM_1ST_ORDER :
								   (pll_dsm_out_sel_1 == "2nd_order") ? PLL_DSM_2ND_ORDER : PLL_DSM_3RD_ORDER;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_carry_out
////////////////////////////////////////////////////////////////////////////////
localparam PLL_COUT_32B = 2'b11 ;
localparam PLL_COUT_24B = 2'b10 ;
localparam PLL_COUT_16B = 2'b01 ;
localparam PLL_COUT_8B = 2'b00 ;
localparam local_pll_fractional_carry_out_0 = (pll_fractional_carry_out_0 == 8) ? PLL_COUT_8B :
											(pll_fractional_carry_out_0 == 16) ? PLL_COUT_16B :
											(pll_fractional_carry_out_0 == 24) ? PLL_COUT_24B : PLL_COUT_32B;
localparam local_pll_fractional_carry_out_1 = (pll_fractional_carry_out_1 == 8) ? PLL_COUT_8B :
											(pll_fractional_carry_out_1 == 16) ? PLL_COUT_16B :
											(pll_fractional_carry_out_1 == 24) ? PLL_COUT_24B : PLL_COUT_32B;

											////////////////////////////////////////////////////////////////////////////////
// pll_dsm_dither
////////////////////////////////////////////////////////////////////////////////
localparam PLL_DITHER_3 = 2'b11 ;
localparam PLL_DITHER_2 = 2'b10 ;
localparam PLL_DITHER_1 = 2'b01 ;
localparam PLL_DITHER_DISABLE = 2'b00 ;
localparam local_pll_dsm_dither_0 = (pll_dsm_dither_0 == "disable") ? PLL_DITHER_DISABLE :
								  (pll_dsm_dither_0 == "pattern1") ? PLL_DITHER_1 :
								  (pll_dsm_dither_0 == "pattern2") ? PLL_DITHER_2 : PLL_DITHER_3;
localparam local_pll_dsm_dither_1 = (pll_dsm_dither_1 == "disable") ? PLL_DITHER_DISABLE :
								  (pll_dsm_dither_1 == "pattern1") ? PLL_DITHER_1 :
								  (pll_dsm_dither_1 == "pattern2") ? PLL_DITHER_2 : PLL_DITHER_3;

////////////////////////////////////////////////////////////////////////////////
// pll_ecn_bypass
////////////////////////////////////////////////////////////////////////////////
localparam PLL_ECN_BYPASS_ENABLE = 1'b1 ;
localparam PLL_ECN_BYPASS_DISABLE = 1'b0 ;
localparam local_pll_ecn_bypass_0 = (pll_ecn_bypass_0 == "false") ? PLL_ECN_BYPASS_DISABLE : PLL_ECN_BYPASS_ENABLE;
localparam local_pll_ecn_bypass_1 = (pll_ecn_bypass_1 == "false") ? PLL_ECN_BYPASS_DISABLE : PLL_ECN_BYPASS_ENABLE;
wire [1:0] fbclk;wire [number_of_counters-1:0] cascade_out_wire;
	stratixv_ffpll_reconfig #(
		.P_XCLKIN_MUX_SO_0__PLL_CLKIN_0_SRC(local_pll_clkin_0_src_0),
		.P_XCLKIN_MUX_SO_0__PLL_CLKIN_1_SRC(local_pll_clkin_1_src_0),
        .P_XCLKIN_MUX_SO_0__PLL_CLK_SW_DLY(local_pll_clk_sw_dly_0), 
        .P_XCLKIN_MUX_SO_0__PLL_CLK_SW_DLY_SETTING(local_pll_clk_sw_dly_0), 	
        .P_XCLKIN_MUX_SO_0__PLL_MANU_CLK_SW_EN(local_pll_manu_clk_sw_en_0),
        .P_XCLKIN_MUX_SO_0__PLL_AUTO_CLK_SW_EN(local_pll_auto_clk_sw_en_0),
        .P_XCLKIN_MUX_SO_0__PLL_CLK_LOSS_SW_EN(local_pll_clk_loss_sw_en_0),
		.P_XCLKIN_MUX_SO_1__PLL_CLKIN_0_SRC(local_pll_clkin_0_src_1),
		.P_XCLKIN_MUX_SO_1__PLL_CLKIN_1_SRC(local_pll_clkin_1_src_1),
        .P_XCLKIN_MUX_SO_1__PLL_CLK_SW_DLY(local_pll_clk_sw_dly_1), 
        .P_XCLKIN_MUX_SO_1__PLL_CLK_SW_DLY_SETTING(local_pll_clk_sw_dly_1), 	
        .P_XCLKIN_MUX_SO_1__PLL_MANU_CLK_SW_EN(local_pll_manu_clk_sw_en_1),
        .P_XCLKIN_MUX_SO_1__PLL_AUTO_CLK_SW_EN(local_pll_auto_clk_sw_en_1),
        .P_XCLKIN_MUX_SO_1__PLL_CLK_LOSS_SW_EN(local_pll_clk_loss_sw_en_1),
    		
        .P_XFPLL_0__PLL_VCO_PH7_EN(local_pll_vco_ph7_en_0),
		.P_XFPLL_0__PLL_VCO_PH6_EN(local_pll_vco_ph6_en_0),
		.P_XFPLL_0__PLL_VCO_PH5_EN(local_pll_vco_ph5_en_0),
		.P_XFPLL_0__PLL_VCO_PH4_EN(local_pll_vco_ph4_en_0),
		.P_XFPLL_0__PLL_VCO_PH3_EN(local_pll_vco_ph3_en_0),
		.P_XFPLL_0__PLL_VCO_PH2_EN(local_pll_vco_ph2_en_0),
		.P_XFPLL_0__PLL_VCO_PH1_EN(local_pll_vco_ph1_en_0),
		.P_XFPLL_0__PLL_VCO_PH0_EN(local_pll_vco_ph0_en_0),
		.P_XFPLL_0__PLL_ENABLE(local_pll_enable_0),
		.P_XFPLL_0__PLL_CTRL_OVERRIDE_SETTING(local_pll_ctrl_override_setting_0),
		.P_XFPLL_0__PLL_FBCLK_MUX_2(local_pll_fbclk_mux_2_0),
		.P_XFPLL_0__PLL_FBCLK_MUX_1(local_pll_fbclk_mux_1_0),
		.P_XFPLL_0__PLL_N_CNT_BYPASS_EN(local_pll_n_cnt_bypass_en_0),
		.P_XFPLL_0__PLL_N_CNT_LO_DIV_SETTING(local_pll_n_cnt_lo_div_setting_0),
		.P_XFPLL_0__PLL_N_CNT_LO_DIV(local_pll_n_cnt_lo_div_0),
		.P_XFPLL_0__PLL_N_CNT_HI_DIV_SETTING(local_pll_n_cnt_hi_div_setting_0),
		.P_XFPLL_0__PLL_N_CNT_HI_DIV(local_pll_n_cnt_hi_div_0),
		.P_XFPLL_0__PLL_N_CNT_ODD_DIV_DUTY_EN(local_pll_n_cnt_odd_div_duty_en_0),
		.P_XFPLL_0__PLL_TCLK_SEL(local_pll_tclk_sel_0),
		.P_XFPLL_0__PLL_M_CNT_ODD_DIV_DUTY_EN(local_pll_m_cnt_odd_div_duty_en_0),
		.P_XFPLL_0__PLL_M_CNT_BYPASS_EN(local_pll_m_cnt_bypass_en_0),
		.P_XFPLL_0__PLL_M_CNT_IN_SRC(local_pll_m_cnt_in_src_0),
		.P_XFPLL_0__PLL_M_CNT_LO_DIV_SETTING(local_pll_m_cnt_lo_div_setting_0),
		.P_XFPLL_0__PLL_M_CNT_LO_DIV(local_pll_m_cnt_lo_div_0),
		.P_XFPLL_0__PLL_M_CNT_HI_DIV_SETTING(local_pll_m_cnt_hi_div_setting_0),
		.P_XFPLL_0__PLL_M_CNT_HI_DIV(local_pll_m_cnt_hi_div_0),
		.P_XFPLL_0__PLL_M_CNT_PRST(local_pll_m_cnt_prst_0),
		.P_XFPLL_0__PLL_M_CNT_PRST_SETTING(local_pll_m_cnt_prst_setting_0),
		.P_XFPLL_0__PLL_UNLOCK_FLTR_CFG_SETTING(local_pll_unlock_fltr_cfg_setting_0),
		.P_XFPLL_0__PLL_UNLOCK_FLTR_CFG(local_pll_unlock_fltr_cfg_0),
		.P_XFPLL_0__PLL_LOCK_FLTR_CFG_SETTING(local_pll_lock_fltr_cfg_setting_0),
		.P_XFPLL_0__PLL_LOCK_FLTR_CFG(local_pll_lock_fltr_cfg_0),
		.P_XFPLL_0__PLL_DSM_OUT_SEL(local_pll_dsm_out_sel_0),
		.P_XFPLL_0__PLL_FRACTIONAL_DIVISION_SETTING(local_pll_fractional_division_setting_0),
		.P_XFPLL_0__PLL_FRACTIONAL_DIVISION(local_pll_fractional_division_0),
		.P_XFPLL_0__PLL_FRACTIONAL_VALUE_READY(local_pll_fractional_value_ready_0),
		.P_XFPLL_0__PLL_FRACTIONAL_CARRY_OUT(local_pll_fractional_carry_out_0),
		.P_XFPLL_0__PLL_ECN_BYPASS(local_pll_ecn_bypass_0),
		.P_XFPLL_0__PLL_DSM_DITHER(local_pll_dsm_dither_0),
        .P_XFPLL_0__PLL_VCO_DIV(1'b1),
        .P_XFPLL_0__PLL_CP_CURRENT(local_pll_cp_current_0),
        .P_XFPLL_0__PLL_BWCTRL(local_pll_bwctrl_0),
		.P_XFPLL_1__PLL_VCO_PH7_EN(local_pll_vco_ph7_en_1),
		.P_XFPLL_1__PLL_VCO_PH6_EN(local_pll_vco_ph6_en_1),
		.P_XFPLL_1__PLL_VCO_PH5_EN(local_pll_vco_ph5_en_1),
		.P_XFPLL_1__PLL_VCO_PH4_EN(local_pll_vco_ph4_en_1),
		.P_XFPLL_1__PLL_VCO_PH3_EN(local_pll_vco_ph3_en_1),
		.P_XFPLL_1__PLL_VCO_PH2_EN(local_pll_vco_ph2_en_1),
		.P_XFPLL_1__PLL_VCO_PH1_EN(local_pll_vco_ph1_en_1),
		.P_XFPLL_1__PLL_VCO_PH0_EN(local_pll_vco_ph0_en_1),
		.P_XFPLL_1__PLL_ENABLE(local_pll_enable_1),
		.P_XFPLL_1__PLL_CTRL_OVERRIDE_SETTING(local_pll_ctrl_override_setting_1),
		.P_XFPLL_1__PLL_FBCLK_MUX_2(local_pll_fbclk_mux_2_1),
		.P_XFPLL_1__PLL_FBCLK_MUX_1(local_pll_fbclk_mux_1_1),
		.P_XFPLL_1__PLL_N_CNT_BYPASS_EN(local_pll_n_cnt_bypass_en_1),
		.P_XFPLL_1__PLL_N_CNT_LO_DIV_SETTING(local_pll_n_cnt_lo_div_setting_1),
		.P_XFPLL_1__PLL_N_CNT_LO_DIV(local_pll_n_cnt_lo_div_1),
		.P_XFPLL_1__PLL_N_CNT_HI_DIV_SETTING(local_pll_n_cnt_hi_div_setting_1),
		.P_XFPLL_1__PLL_N_CNT_HI_DIV(local_pll_n_cnt_hi_div_1),
		.P_XFPLL_1__PLL_N_CNT_ODD_DIV_DUTY_EN(local_pll_n_cnt_odd_div_duty_en_1),
		.P_XFPLL_1__PLL_TCLK_SEL(local_pll_tclk_sel_1),
		.P_XFPLL_1__PLL_M_CNT_ODD_DIV_DUTY_EN(local_pll_m_cnt_odd_div_duty_en_1),
		.P_XFPLL_1__PLL_M_CNT_BYPASS_EN(local_pll_m_cnt_bypass_en_1),
		.P_XFPLL_1__PLL_M_CNT_IN_SRC(local_pll_m_cnt_in_src_1),
		.P_XFPLL_1__PLL_M_CNT_LO_DIV_SETTING(local_pll_m_cnt_lo_div_setting_1),
		.P_XFPLL_1__PLL_M_CNT_LO_DIV(local_pll_m_cnt_lo_div_1),
		.P_XFPLL_1__PLL_M_CNT_HI_DIV_SETTING(local_pll_m_cnt_hi_div_setting_1),
		.P_XFPLL_1__PLL_M_CNT_HI_DIV(local_pll_m_cnt_hi_div_1),
		.P_XFPLL_1__PLL_M_CNT_PRST(local_pll_m_cnt_prst_1),
		.P_XFPLL_1__PLL_M_CNT_PRST_SETTING(local_pll_m_cnt_prst_setting_1),
		.P_XFPLL_1__PLL_UNLOCK_FLTR_CFG_SETTING(local_pll_unlock_fltr_cfg_setting_1),
		.P_XFPLL_1__PLL_UNLOCK_FLTR_CFG(local_pll_unlock_fltr_cfg_1),
		.P_XFPLL_1__PLL_LOCK_FLTR_CFG_SETTING(local_pll_lock_fltr_cfg_setting_1),
		.P_XFPLL_1__PLL_LOCK_FLTR_CFG(local_pll_lock_fltr_cfg_1),
		.P_XFPLL_1__PLL_DSM_OUT_SEL(local_pll_dsm_out_sel_1),
		.P_XFPLL_1__PLL_FRACTIONAL_DIVISION_SETTING(local_pll_fractional_division_setting_1),
		.P_XFPLL_1__PLL_FRACTIONAL_DIVISION(local_pll_fractional_division_1),
		.P_XFPLL_1__PLL_FRACTIONAL_VALUE_READY(local_pll_fractional_value_ready_1),
		.P_XFPLL_1__PLL_FRACTIONAL_CARRY_OUT(local_pll_fractional_carry_out_1),
		.P_XFPLL_1__PLL_DSM_DITHER(local_pll_dsm_dither_1),
		.P_XFPLL_1__PLL_ECN_BYPASS(local_pll_ecn_bypass_1),
        .P_XFPLL_1__PLL_VCO_DIV(1'b1),
        .P_XFPLL_1__PLL_CP_CURRENT(local_pll_cp_current_1),
        .P_XFPLL_1__PLL_BWCTRL(local_pll_bwctrl_1),

        .P_X18CCNTS__XCCNT_0__C_CNT_IN_SRC(local_c_cnt_in_src_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PRST(local_c_cnt_prst_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PRST_USER(local_c_cnt_prst_user_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_0),
		.P_X18CCNTS__XCCNT_1__C_CNT_IN_SRC(local_c_cnt_in_src_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PRST(local_c_cnt_prst_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PRST_USER(local_c_cnt_prst_user_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_1),
		.P_X18CCNTS__XCCNT_2__C_CNT_IN_SRC(local_c_cnt_in_src_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PRST(local_c_cnt_prst_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PRST_USER(local_c_cnt_prst_user_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_2),
		.P_X18CCNTS__XCCNT_3__C_CNT_IN_SRC(local_c_cnt_in_src_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PRST(local_c_cnt_prst_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PRST_USER(local_c_cnt_prst_user_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_3),
		.P_X18CCNTS__XCCNT_4__C_CNT_IN_SRC(local_c_cnt_in_src_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PRST(local_c_cnt_prst_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PRST_USER(local_c_cnt_prst_user_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_4),
		.P_X18CCNTS__XCCNT_5__C_CNT_IN_SRC(local_c_cnt_in_src_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PRST(local_c_cnt_prst_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PRST_USER(local_c_cnt_prst_user_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_5),
		.P_X18CCNTS__XCCNT_6__C_CNT_IN_SRC(local_c_cnt_in_src_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PRST(local_c_cnt_prst_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PRST_USER(local_c_cnt_prst_user_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_6),
		.P_X18CCNTS__XCCNT_7__C_CNT_IN_SRC(local_c_cnt_in_src_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PRST(local_c_cnt_prst_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PRST_USER(local_c_cnt_prst_user_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_7),
		.P_X18CCNTS__XCCNT_8__C_CNT_IN_SRC(local_c_cnt_in_src_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PRST(local_c_cnt_prst_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PRST_USER(local_c_cnt_prst_user_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_8),
		.P_X18CCNTS__XCCNT_9__C_CNT_IN_SRC(local_c_cnt_in_src_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PRST(local_c_cnt_prst_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PRST_USER(local_c_cnt_prst_user_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_9),
		.P_X18CCNTS__XCCNT_10__C_CNT_IN_SRC(local_c_cnt_in_src_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PRST(local_c_cnt_prst_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PRST_USER(local_c_cnt_prst_user_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_10),
		.P_X18CCNTS__XCCNT_11__C_CNT_IN_SRC(local_c_cnt_in_src_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PRST(local_c_cnt_prst_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PRST_USER(local_c_cnt_prst_user_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_11),
		.P_X18CCNTS__XCCNT_12__C_CNT_IN_SRC(local_c_cnt_in_src_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PRST(local_c_cnt_prst_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PRST_USER(local_c_cnt_prst_user_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_12),
		.P_X18CCNTS__XCCNT_13__C_CNT_IN_SRC(local_c_cnt_in_src_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PRST(local_c_cnt_prst_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PRST_USER(local_c_cnt_prst_user_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_13),
		.P_X18CCNTS__XCCNT_14__C_CNT_IN_SRC(local_c_cnt_in_src_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PRST(local_c_cnt_prst_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PRST_USER(local_c_cnt_prst_user_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_14),
		.P_X18CCNTS__XCCNT_15__C_CNT_IN_SRC(local_c_cnt_in_src_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PRST(local_c_cnt_prst_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PRST_USER(local_c_cnt_prst_user_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_15),
		.P_X18CCNTS__XCCNT_16__C_CNT_IN_SRC(local_c_cnt_in_src_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PRST(local_c_cnt_prst_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PRST_USER(local_c_cnt_prst_user_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_16),
		.P_X18CCNTS__XCCNT_17__C_CNT_IN_SRC(local_c_cnt_in_src_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PRST(local_c_cnt_prst_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PRST_USER(local_c_cnt_prst_user_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_17)		
	) stratixv_ffpll_inst (
	  // stratixv_pll_dpa_output pins
	  .dpaclk0_i(phout_0),
	  .dpaclk1_i(phout_1),
	  
	  // stratixv_pll_refclk_select pins
	  .pll_cas_in0(adjpllin[0]),
	  .coreclk0(coreclkin[0]),	  	  .coreclk1(cclk[0]),
	  .extswitch0(extswitch[0]),
	  .iqtxrxclk_fpll0(iqtxrxclkin[0]),
	  .ref_iqclk_fpll0(plliqclkin[0]),
	  .rx_iqclk_fpll0(rxiqclkin[0]),
	  .clkin(clkin),
	  .refclk_fpll0(refiqclk_0[0]),
	  .clk0_bad0(clk0bad[0]),
	  .clk1_bad0(clk1bad[0]),
	  .clksel0(pllclksel[0]),

	  // stratixv_pll_reconfig pins
	  .atpgmode0(atpgmode[0]),
	  .dprio0_clk(clk[0]),
	  .ffpll_csr_test0(fpllcsrtest[0]),
	  .iocsr_clkin(iocsrclkin[0]),
	  .iocsr_datain(iocsrdatain[0]),
	  .dprio0_mdio_dis(mdiodis[0]),
	  .phase_en0(phaseen[0]),
	  .dprio0_read(read[0]),
	  .dprio0_rst_n(rstn[0]),
	  .scanen0(scanen[0]),
	  .dprio0_ser_shift_load(sershiftload[0]),
	  .up_dn0(updn[0]),
	  .dprio0_write(write[0]),
	  .dprio0_reg_addr(addr_0),
	  .dprio1_reg_addr(addr_1),
	  .dprio0_byte_en(byteen_0),
	  .dprio1_byte_en(byteen_1),
	  .cnt_sel0(cntsel_0),
	  .cnt_sel1(cntsel_1),
	  .dprio0_writedata(din_0),
	  .dprio1_writedata(din_1),
	  .dprio0_block_select(blockselect[0]),
	  .iocsr_dataout(iocsrdataout[0]),
	  .phase_done0(phasedone[0]),
	  .dprio0_readdata(dout_0),
	  .dprio1_readdata(dout_1),
	  
	  // stratixv_fractional_pll pins
          .pllmout0(fbclk[0]),
          .fbclk_in0(fbclk[0]),
	  .fbclk_fpll0(fbclkfpll[0]),
	  .fblvds_in0(lvdfbin[0]),
	  .nreset0(nresync[0]),
	  .pfden0(pfden[0]),
	  .zdb_in0(zdb[0]),
	  .fblvds_out0(fblvdsout[0]),
	  .lock0(lock[0]),
	  
	  // stratixv_pll_extclk_output pins
	  .clken(clken),
	  .extclk(extclk),
	  
	  // stratixv_pll_dll_output pins
	  .plldout0(clkout[0]),
	  
	  // stratixv_pll_lvds_output pins
	  .loaden0({loaden[1], loaden[0]}),
	  .loaden1({loaden[3], loaden[2]}),
	  .lvds_clk0({lvdsclk[1], lvdsclk[0]}),
	  .lvds_clk1({lvdsclk[1], lvdsclk[0]}),
	  
	  // stratixv_pll_output_counter pins
	  .divclk(divclk),
	  .pll_cas_out1(),
	  // others
	  .ioplniotri(nresync[0]),
	  .nfrzdrv(nresync[0]),
	  .pllbias(nresync[0])
	);	// assign cascade_out to divclk	// This is used as a workaround in RTL simulation as cascade_out needs to be output counter location dependent	assign cascade_out = divclk;

endmodule
`timescale 1 ps/1 ps

module altera_arriav_pll
#(	
	// Parameter declarations and default value assignments
	parameter number_of_counters = 18,	
	parameter number_of_fplls = 1,
	parameter number_of_extclks = 4,
	parameter number_of_dlls = 2,
	parameter number_of_lvds = 4,

	// arriav_pll_refclk_select parameters -- FF_PLL 0
	parameter pll_auto_clk_sw_en_0 = "false",
	parameter pll_clk_loss_edge_0 = "both_edges",
	parameter pll_clk_loss_sw_en_0 = "false",
	parameter pll_clk_sw_dly_0 = 0,
	parameter pll_clkin_0_src_0 = "clk_0",
	parameter pll_clkin_1_src_0 = "clk_0",
	parameter pll_manu_clk_sw_en_0 = "false",
	parameter pll_sw_refclk_src_0 = "clk_0",
	
	// arriav_pll_refclk_select parameters -- FF_PLL 1
	parameter pll_auto_clk_sw_en_1 = "false",
	parameter pll_clk_loss_edge_1 = "both_edges",
	parameter pll_clk_loss_sw_en_1 = "false",
	parameter pll_clk_sw_dly_1 = 0,
	parameter pll_clkin_0_src_1 = "clk_1",
	parameter pll_clkin_1_src_1 = "clk_1",
	parameter pll_manu_clk_sw_en_1 = "false",
	parameter pll_sw_refclk_src_1 = "clk_1",
	
	// arriav_fractional_pll parameters -- FF_PLL 0
	parameter pll_output_clock_frequency_0 = "700.0 MHz",
	parameter reference_clock_frequency_0 = "700.0 MHz",
	parameter mimic_fbclk_type_0 = "gclk",
	parameter dsm_accumulator_reset_value_0 = 0,
	parameter forcelock_0 = "false",
	parameter nreset_invert_0 = "false",
	parameter pll_atb_0 = 0,
	parameter pll_bwctrl_0 = 1000,
	parameter pll_cmp_buf_dly_0 = "0 ps",
	parameter pll_cp_comp_0 = "true",
	parameter pll_cp_current_0 = 20,
	parameter pll_ctrl_override_setting_0 = "true",
	parameter pll_dsm_dither_0 = "disable",
	parameter pll_dsm_out_sel_0 = "disable",
	parameter pll_dsm_reset_0 = "false",
	parameter pll_ecn_bypass_0 = "false",
	parameter pll_ecn_test_en_0 = "false",
	parameter pll_enable_0 = "true",
	parameter pll_fbclk_mux_1_0 = "fb",
	parameter pll_fbclk_mux_2_0 = "m_cnt",
	parameter pll_fractional_carry_out_0 = 24,
	parameter pll_fractional_division_0 = 1,
	parameter pll_fractional_value_ready_0 = "true",
	parameter pll_lf_testen_0 = "false",
	parameter pll_lock_fltr_cfg_0 = 25,
	parameter pll_lock_fltr_test_0 = "false",
	parameter pll_m_cnt_bypass_en_0 = "false",
	parameter pll_m_cnt_coarse_dly_0 = "0 ps",
	parameter pll_m_cnt_fine_dly_0 = "0 ps",
	parameter pll_m_cnt_hi_div_0 = 3,
	parameter pll_m_cnt_in_src_0 = "ph_mux_clk",
	parameter pll_m_cnt_lo_div_0 = 3,
	parameter pll_m_cnt_odd_div_duty_en_0 = "false",
	parameter pll_m_cnt_ph_mux_prst_0 = 0,
	parameter pll_m_cnt_prst_0 = 256,
	parameter pll_n_cnt_bypass_en_0 = "true",
	parameter pll_n_cnt_coarse_dly_0 = "0 ps",
	parameter pll_n_cnt_fine_dly_0 = "0 ps",
	parameter pll_n_cnt_hi_div_0 = 1,
	parameter pll_n_cnt_lo_div_0 = 1,
	parameter pll_n_cnt_odd_div_duty_en_0 = "false",
	parameter pll_ref_buf_dly_0 = "0 ps",
	parameter pll_reg_boost_0 = 0,
	parameter pll_regulator_bypass_0 = "false",
	parameter pll_ripplecap_ctrl_0 = 0,
	parameter pll_slf_rst_0 = "false",
	parameter pll_tclk_mux_en_0 = "false",
	parameter pll_tclk_sel_0 = "n_src",
	parameter pll_test_enable_0 = "false",
	parameter pll_testdn_enable_0 = "false",
	parameter pll_testup_enable_0 = "false",
	parameter pll_unlock_fltr_cfg_0 = 1,
	parameter pll_vco_div_0 = 0,
	parameter pll_vco_ph0_en_0 = "true",
	parameter pll_vco_ph1_en_0 = "true",
	parameter pll_vco_ph2_en_0 = "true",
	parameter pll_vco_ph3_en_0 = "true",
	parameter pll_vco_ph4_en_0 = "true",
	parameter pll_vco_ph5_en_0 = "true",
	parameter pll_vco_ph6_en_0 = "true",
	parameter pll_vco_ph7_en_0 = "true",
	parameter pll_vctrl_test_voltage_0 = 750,
	parameter vccd0g_atb_0 = "disable",
	parameter vccd0g_output_0 = 0,
	parameter vccd1g_atb_0 = "disable",
	parameter vccd1g_output_0 = 0,
	parameter vccm1g_tap_0 = 2,
	parameter vccr_pd_0 = "false",
	parameter vcodiv_override_0 = "false",
    parameter sim_use_fast_model_0 = "false",

	// arriav_fractional_pll parameters -- FF_PLL 1
	parameter pll_output_clock_frequency_1 = "300.0 MHz",
	parameter reference_clock_frequency_1 = "100.0 MHz",
	parameter mimic_fbclk_type_1 = "gclk",
	parameter dsm_accumulator_reset_value_1 = 0,
	parameter forcelock_1 = "false",
	parameter nreset_invert_1 = "false",
	parameter pll_atb_1 = 0,
	parameter pll_bwctrl_1 = 1000,
	parameter pll_cmp_buf_dly_1 = "0 ps",
	parameter pll_cp_comp_1 = "true",
	parameter pll_cp_current_1 = 30,
	parameter pll_ctrl_override_setting_1 = "false",
	parameter pll_dsm_dither_1 = "disable",
	parameter pll_dsm_out_sel_1 = "disable",
	parameter pll_dsm_reset_1 = "false",
	parameter pll_ecn_bypass_1 = "false",
	parameter pll_ecn_test_en_1 = "false",
	parameter pll_enable_1 = "false",
	parameter pll_fbclk_mux_1_1 = "glb",
	parameter pll_fbclk_mux_2_1 = "fb_1",
	parameter pll_fractional_carry_out_1 = 24,
	parameter pll_fractional_division_1 = 1,
	parameter pll_fractional_value_ready_1 = "true",
	parameter pll_lf_testen_1 = "false",
	parameter pll_lock_fltr_cfg_1 = 25,
	parameter pll_lock_fltr_test_1 = "false",
	parameter pll_m_cnt_bypass_en_1 = "false",
	parameter pll_m_cnt_coarse_dly_1 = "0 ps",
	parameter pll_m_cnt_fine_dly_1 = "0 ps",
	parameter pll_m_cnt_hi_div_1 = 2,
	parameter pll_m_cnt_in_src_1 = "ph_mux_clk",
	parameter pll_m_cnt_lo_div_1 = 1,
	parameter pll_m_cnt_odd_div_duty_en_1 = "true",
	parameter pll_m_cnt_ph_mux_prst_1 = 0,
	parameter pll_m_cnt_prst_1 = 256,
	parameter pll_n_cnt_bypass_en_1 = "true",
	parameter pll_n_cnt_coarse_dly_1 = "0 ps",
	parameter pll_n_cnt_fine_dly_1 = "0 ps",
	parameter pll_n_cnt_hi_div_1 = 256,
	parameter pll_n_cnt_lo_div_1 = 256,
	parameter pll_n_cnt_odd_div_duty_en_1 = "false",
	parameter pll_ref_buf_dly_1 = "0 ps",
	parameter pll_reg_boost_1 = 0,
	parameter pll_regulator_bypass_1 = "false",
	parameter pll_ripplecap_ctrl_1 = 0,
	parameter pll_slf_rst_1 = "false",
	parameter pll_tclk_mux_en_1 = "false",
	parameter pll_tclk_sel_1 = "n_src",
	parameter pll_test_enable_1 = "false",
	parameter pll_testdn_enable_1 = "false",
	parameter pll_testup_enable_1 = "false",
	parameter pll_unlock_fltr_cfg_1 = 2,
	parameter pll_vco_div_1 = 1,
	parameter pll_vco_ph0_en_1 = "true",
	parameter pll_vco_ph1_en_1 = "true",
	parameter pll_vco_ph2_en_1 = "true",
	parameter pll_vco_ph3_en_1 = "true",
	parameter pll_vco_ph4_en_1 = "true",
	parameter pll_vco_ph5_en_1 = "true",
	parameter pll_vco_ph6_en_1 = "true",
	parameter pll_vco_ph7_en_1 = "true",
	parameter pll_vctrl_test_voltage_1 = 750,
	parameter vccd0g_atb_1 = "disable",
	parameter vccd0g_output_1 = 0,
	parameter vccd1g_atb_1 = "disable",
	parameter vccd1g_output_1 = 0,
	parameter vccm1g_tap_1 = 2,
	parameter vccr_pd_1 = "false",
	parameter vcodiv_override_1 = "false",
    parameter sim_use_fast_model_1 = "false",
    
	// arriav_pll_output_counter parameters -- counter 0
	parameter output_clock_frequency_0 = "100.0 MHz",
	parameter enable_output_counter_0 = "true",
	parameter phase_shift_0 = "0 ps",
	parameter duty_cycle_0 = 50,
	parameter c_cnt_coarse_dly_0 = "0 ps",
	parameter c_cnt_fine_dly_0 = "0 ps",
	parameter c_cnt_in_src_0 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_0 = 0,
	parameter c_cnt_prst_0 = 1,
	parameter cnt_fpll_src_0 = "fpll_0",
	parameter dprio0_cnt_bypass_en_0 = "true",
	parameter dprio0_cnt_hi_div_0 = 3,
	parameter dprio0_cnt_lo_div_0 = 3,
	parameter dprio0_cnt_odd_div_even_duty_en_0 = "false",
	parameter dprio1_cnt_bypass_en_0 = dprio0_cnt_bypass_en_0,
	parameter dprio1_cnt_hi_div_0 = dprio0_cnt_hi_div_0,
	parameter dprio1_cnt_lo_div_0 = dprio0_cnt_lo_div_0,
	parameter dprio1_cnt_odd_div_even_duty_en_0 = dprio0_cnt_odd_div_even_duty_en_0,
	
	parameter output_clock_frequency_1 = "0 ps",
	parameter enable_output_counter_1 = "true",
	parameter phase_shift_1 = "0 ps",
	parameter duty_cycle_1 = 50,
	parameter c_cnt_coarse_dly_1 = "0 ps",
	parameter c_cnt_fine_dly_1 = "0 ps",
	parameter c_cnt_in_src_1 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_1 = 0,
	parameter c_cnt_prst_1 = 1,
	parameter cnt_fpll_src_1 = "fpll_0",
	parameter dprio0_cnt_bypass_en_1 = "true",
	parameter dprio0_cnt_hi_div_1 = 2,
	parameter dprio0_cnt_lo_div_1 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_1 = "true",
	parameter dprio1_cnt_bypass_en_1 = dprio0_cnt_bypass_en_1,
	parameter dprio1_cnt_hi_div_1 = dprio0_cnt_hi_div_1,
	parameter dprio1_cnt_lo_div_1 = dprio0_cnt_lo_div_1,
	parameter dprio1_cnt_odd_div_even_duty_en_1 = dprio0_cnt_odd_div_even_duty_en_1,
	
	parameter output_clock_frequency_2 = "0 ps",
	parameter enable_output_counter_2 = "true",
	parameter phase_shift_2 = "0 ps",
	parameter duty_cycle_2 = 50,
	parameter c_cnt_coarse_dly_2 = "0 ps",
	parameter c_cnt_fine_dly_2 = "0 ps",
	parameter c_cnt_in_src_2 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_2 = 0,
	parameter c_cnt_prst_2 = 1,
	parameter cnt_fpll_src_2 = "fpll_0",
	parameter dprio0_cnt_bypass_en_2 = "true",
	parameter dprio0_cnt_hi_div_2 = 1,
	parameter dprio0_cnt_lo_div_2 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_2 = "false",
	parameter dprio1_cnt_bypass_en_2 = dprio0_cnt_bypass_en_2,
	parameter dprio1_cnt_hi_div_2 = dprio0_cnt_hi_div_2,
	parameter dprio1_cnt_lo_div_2 = dprio0_cnt_lo_div_2,
	parameter dprio1_cnt_odd_div_even_duty_en_2 = dprio0_cnt_odd_div_even_duty_en_2,
	
	parameter output_clock_frequency_3 = "0 ps",
	parameter enable_output_counter_3 = "true",
	parameter phase_shift_3 = "0 ps",
	parameter duty_cycle_3 = 50,
	parameter c_cnt_coarse_dly_3 = "0 ps",
	parameter c_cnt_fine_dly_3 = "0 ps",
	parameter c_cnt_in_src_3 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_3 = 0,
	parameter c_cnt_prst_3 = 1,
	parameter cnt_fpll_src_3 = "fpll_0",
	parameter dprio0_cnt_bypass_en_3 = "false",
	parameter dprio0_cnt_hi_div_3 = 1,
	parameter dprio0_cnt_lo_div_3 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_3 = "false",
	parameter dprio1_cnt_bypass_en_3 = dprio0_cnt_bypass_en_3,
	parameter dprio1_cnt_hi_div_3 = dprio0_cnt_hi_div_3,
	parameter dprio1_cnt_lo_div_3 = dprio0_cnt_lo_div_3,
	parameter dprio1_cnt_odd_div_even_duty_en_3 = dprio0_cnt_odd_div_even_duty_en_3,
	
	parameter output_clock_frequency_4 = "0 ps",
	parameter enable_output_counter_4 = "true",
	parameter phase_shift_4 = "0 ps",
	parameter duty_cycle_4 = 50,
	parameter c_cnt_coarse_dly_4 = "0 ps",
	parameter c_cnt_fine_dly_4 = "0 ps",
	parameter c_cnt_in_src_4 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_4 = 0,
	parameter c_cnt_prst_4 = 1,
	parameter cnt_fpll_src_4 = "fpll_0",
	parameter dprio0_cnt_bypass_en_4 = "false",
	parameter dprio0_cnt_hi_div_4 = 1,
	parameter dprio0_cnt_lo_div_4 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_4 = "false",
	parameter dprio1_cnt_bypass_en_4 = dprio0_cnt_bypass_en_4,
	parameter dprio1_cnt_hi_div_4 = dprio0_cnt_hi_div_4,
	parameter dprio1_cnt_lo_div_4 = dprio0_cnt_lo_div_4,
	parameter dprio1_cnt_odd_div_even_duty_en_4 = dprio0_cnt_odd_div_even_duty_en_4,
	
	parameter output_clock_frequency_5 = "0 ps",
	parameter enable_output_counter_5 = "true",
	parameter phase_shift_5 = "0 ps",
	parameter duty_cycle_5 = 50,
	parameter c_cnt_coarse_dly_5 = "0 ps",
	parameter c_cnt_fine_dly_5 = "0 ps",
	parameter c_cnt_in_src_5 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_5 = 0,
	parameter c_cnt_prst_5 = 1,
	parameter cnt_fpll_src_5 = "fpll_0",
	parameter dprio0_cnt_bypass_en_5 = "false",
	parameter dprio0_cnt_hi_div_5 = 1,
	parameter dprio0_cnt_lo_div_5 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_5 = "false",
	parameter dprio1_cnt_bypass_en_5 = dprio0_cnt_bypass_en_5,
	parameter dprio1_cnt_hi_div_5 = dprio0_cnt_hi_div_5,
	parameter dprio1_cnt_lo_div_5 = dprio0_cnt_lo_div_5,
	parameter dprio1_cnt_odd_div_even_duty_en_5 = dprio0_cnt_odd_div_even_duty_en_5,
	
	parameter output_clock_frequency_6 = "0 ps",
	parameter enable_output_counter_6 = "true",
	parameter phase_shift_6 = "0 ps",
	parameter duty_cycle_6 = 50,
	parameter c_cnt_coarse_dly_6 = "0 ps",
	parameter c_cnt_fine_dly_6 = "0 ps",
	parameter c_cnt_in_src_6 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_6 = 0,
	parameter c_cnt_prst_6 = 1,
	parameter cnt_fpll_src_6 = "fpll_0",
	parameter dprio0_cnt_bypass_en_6 = "false",
	parameter dprio0_cnt_hi_div_6 = 1,
	parameter dprio0_cnt_lo_div_6 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_6 = "false",
	parameter dprio1_cnt_bypass_en_6 = dprio0_cnt_bypass_en_6,
	parameter dprio1_cnt_hi_div_6 = dprio0_cnt_hi_div_6,
	parameter dprio1_cnt_lo_div_6 = dprio0_cnt_lo_div_6,
	parameter dprio1_cnt_odd_div_even_duty_en_6 = dprio0_cnt_odd_div_even_duty_en_6,
	
	parameter output_clock_frequency_7 = "0 ps",
	parameter enable_output_counter_7 = "true",
	parameter phase_shift_7 = "0 ps",
	parameter duty_cycle_7 = 50,
	parameter c_cnt_coarse_dly_7 = "0 ps",
	parameter c_cnt_fine_dly_7 = "0 ps",
	parameter c_cnt_in_src_7 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_7 = 0,
	parameter c_cnt_prst_7 = 1,
	parameter cnt_fpll_src_7 = "fpll_0",
	parameter dprio0_cnt_bypass_en_7 = "false",
	parameter dprio0_cnt_hi_div_7 = 1,
	parameter dprio0_cnt_lo_div_7 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_7 = "false",
	parameter dprio1_cnt_bypass_en_7 = dprio0_cnt_bypass_en_7,
	parameter dprio1_cnt_hi_div_7 = dprio0_cnt_hi_div_7,
	parameter dprio1_cnt_lo_div_7 = dprio0_cnt_lo_div_7,
	parameter dprio1_cnt_odd_div_even_duty_en_7 = dprio0_cnt_odd_div_even_duty_en_7,
	
	parameter output_clock_frequency_8 = "0 ps",
	parameter enable_output_counter_8 = "true",
	parameter phase_shift_8 = "0 ps",
	parameter duty_cycle_8 = 50,
	parameter c_cnt_coarse_dly_8 = "0 ps",
	parameter c_cnt_fine_dly_8 = "0 ps",
	parameter c_cnt_in_src_8 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_8 = 0,
	parameter c_cnt_prst_8 = 1,
	parameter cnt_fpll_src_8 = "fpll_0",
	parameter dprio0_cnt_bypass_en_8 = "false",
	parameter dprio0_cnt_hi_div_8 = 1,
	parameter dprio0_cnt_lo_div_8 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_8 = "false",
	parameter dprio1_cnt_bypass_en_8 = dprio0_cnt_bypass_en_8,
	parameter dprio1_cnt_hi_div_8 = dprio0_cnt_hi_div_8,
	parameter dprio1_cnt_lo_div_8 = dprio0_cnt_lo_div_8,
	parameter dprio1_cnt_odd_div_even_duty_en_8 = dprio0_cnt_odd_div_even_duty_en_8,
	
	parameter output_clock_frequency_9 = "0 ps",
	parameter enable_output_counter_9 = "true",
	parameter phase_shift_9 = "0 ps",
	parameter duty_cycle_9 = 50,
	parameter c_cnt_coarse_dly_9 = "0 ps",
	parameter c_cnt_fine_dly_9 = "0 ps",
	parameter c_cnt_in_src_9 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_9 = 0,
	parameter c_cnt_prst_9 = 1,
	parameter cnt_fpll_src_9 = "fpll_0",
	parameter dprio0_cnt_bypass_en_9 = "false",
	parameter dprio0_cnt_hi_div_9 = 1,
	parameter dprio0_cnt_lo_div_9 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_9 = "false",
	parameter dprio1_cnt_bypass_en_9 = dprio0_cnt_bypass_en_9,
	parameter dprio1_cnt_hi_div_9 = dprio0_cnt_hi_div_9,
	parameter dprio1_cnt_lo_div_9 = dprio0_cnt_lo_div_9,
	parameter dprio1_cnt_odd_div_even_duty_en_9 = dprio0_cnt_odd_div_even_duty_en_9,
	
	parameter output_clock_frequency_10 = "0 ps",
	parameter enable_output_counter_10 = "true",
	parameter phase_shift_10 = "0 ps",
	parameter duty_cycle_10 = 50,
	parameter c_cnt_coarse_dly_10 = "0 ps",
	parameter c_cnt_fine_dly_10 = "0 ps",
	parameter c_cnt_in_src_10 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_10 = 0,
	parameter c_cnt_prst_10 = 1,
	parameter cnt_fpll_src_10 = "fpll_0",
	parameter dprio0_cnt_bypass_en_10 = "false",
	parameter dprio0_cnt_hi_div_10 = 1,
	parameter dprio0_cnt_lo_div_10 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_10 = "false",
	parameter dprio1_cnt_bypass_en_10 = dprio0_cnt_bypass_en_10,
	parameter dprio1_cnt_hi_div_10 = dprio0_cnt_hi_div_10,
	parameter dprio1_cnt_lo_div_10 = dprio0_cnt_lo_div_10,
	parameter dprio1_cnt_odd_div_even_duty_en_10 = dprio0_cnt_odd_div_even_duty_en_10,
	
	parameter output_clock_frequency_11 = "0 ps",
	parameter enable_output_counter_11 = "true",
	parameter phase_shift_11 = "0 ps",
	parameter duty_cycle_11 = 50,
	parameter c_cnt_coarse_dly_11 = "0 ps",
	parameter c_cnt_fine_dly_11 = "0 ps",
	parameter c_cnt_in_src_11 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_11 = 0,
	parameter c_cnt_prst_11 = 1,
	parameter cnt_fpll_src_11 = "fpll_0",
	parameter dprio0_cnt_bypass_en_11 = "false",
	parameter dprio0_cnt_hi_div_11 = 1,
	parameter dprio0_cnt_lo_div_11 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_11 = "false",
	parameter dprio1_cnt_bypass_en_11 = dprio0_cnt_bypass_en_11,
	parameter dprio1_cnt_hi_div_11 = dprio0_cnt_hi_div_11,
	parameter dprio1_cnt_lo_div_11 = dprio0_cnt_lo_div_11,
	parameter dprio1_cnt_odd_div_even_duty_en_11 = dprio0_cnt_odd_div_even_duty_en_11,
	
	parameter output_clock_frequency_12 = "0 ps",
	parameter enable_output_counter_12 = "true",
	parameter phase_shift_12 = "0 ps",
	parameter duty_cycle_12 = 50,
	parameter c_cnt_coarse_dly_12 = "0 ps",
	parameter c_cnt_fine_dly_12 = "0 ps",
	parameter c_cnt_in_src_12 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_12 = 0,
	parameter c_cnt_prst_12 = 1,
	parameter cnt_fpll_src_12 = "fpll_0",
	parameter dprio0_cnt_bypass_en_12 = "false",
	parameter dprio0_cnt_hi_div_12 = 1,
	parameter dprio0_cnt_lo_div_12 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_12 = "false",
	parameter dprio1_cnt_bypass_en_12 = dprio0_cnt_bypass_en_12,
	parameter dprio1_cnt_hi_div_12 = dprio0_cnt_hi_div_12,
	parameter dprio1_cnt_lo_div_12 = dprio0_cnt_lo_div_12,
	parameter dprio1_cnt_odd_div_even_duty_en_12 = dprio0_cnt_odd_div_even_duty_en_12,
	
	parameter output_clock_frequency_13 = "0 ps",
	parameter enable_output_counter_13 = "true",
	parameter phase_shift_13 = "0 ps",
	parameter duty_cycle_13 = 50,
	parameter c_cnt_coarse_dly_13 = "0 ps",
	parameter c_cnt_fine_dly_13 = "0 ps",
	parameter c_cnt_in_src_13 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_13 = 0,
	parameter c_cnt_prst_13 = 1,
	parameter cnt_fpll_src_13 = "fpll_0",
	parameter dprio0_cnt_bypass_en_13 = "false",
	parameter dprio0_cnt_hi_div_13 = 1,
	parameter dprio0_cnt_lo_div_13 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_13 = "false",
	parameter dprio1_cnt_bypass_en_13 = dprio0_cnt_bypass_en_13,
	parameter dprio1_cnt_hi_div_13 = dprio0_cnt_hi_div_13,
	parameter dprio1_cnt_lo_div_13 = dprio0_cnt_lo_div_13,
	parameter dprio1_cnt_odd_div_even_duty_en_13 = dprio0_cnt_odd_div_even_duty_en_13,
	
	parameter output_clock_frequency_14 = "0 ps",
	parameter enable_output_counter_14 = "true",
	parameter phase_shift_14 = "0 ps",
	parameter duty_cycle_14 = 50,
	parameter c_cnt_coarse_dly_14 = "0 ps",
	parameter c_cnt_fine_dly_14 = "0 ps",
	parameter c_cnt_in_src_14 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_14 = 0,
	parameter c_cnt_prst_14 = 1,
	parameter cnt_fpll_src_14 = "fpll_0",
	parameter dprio0_cnt_bypass_en_14 = "false",
	parameter dprio0_cnt_hi_div_14 = 1,
	parameter dprio0_cnt_lo_div_14 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_14 = "false",
	parameter dprio1_cnt_bypass_en_14 = dprio0_cnt_bypass_en_14,
	parameter dprio1_cnt_hi_div_14 = dprio0_cnt_hi_div_14,
	parameter dprio1_cnt_lo_div_14 = dprio0_cnt_lo_div_14,
	parameter dprio1_cnt_odd_div_even_duty_en_14 = dprio0_cnt_odd_div_even_duty_en_14,
	
	parameter output_clock_frequency_15 = "0 ps",
	parameter enable_output_counter_15 = "true",
	parameter phase_shift_15 = "0 ps",
	parameter duty_cycle_15 = 50,
	parameter c_cnt_coarse_dly_15 = "0 ps",
	parameter c_cnt_fine_dly_15 = "0 ps",
	parameter c_cnt_in_src_15 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_15 = 0,
	parameter c_cnt_prst_15 = 1,
	parameter cnt_fpll_src_15 = "fpll_0",
	parameter dprio0_cnt_bypass_en_15 = "false",
	parameter dprio0_cnt_hi_div_15 = 1,
	parameter dprio0_cnt_lo_div_15 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_15 = "false",
	parameter dprio1_cnt_bypass_en_15 = dprio0_cnt_bypass_en_15,
	parameter dprio1_cnt_hi_div_15 = dprio0_cnt_hi_div_15,
	parameter dprio1_cnt_lo_div_15 = dprio0_cnt_lo_div_15,
	parameter dprio1_cnt_odd_div_even_duty_en_15 = dprio0_cnt_odd_div_even_duty_en_15,
	
	parameter output_clock_frequency_16 = "0 ps",
	parameter enable_output_counter_16 = "true",
	parameter phase_shift_16 = "0 ps",
	parameter duty_cycle_16 = 50,
	parameter c_cnt_coarse_dly_16 = "0 ps",
	parameter c_cnt_fine_dly_16 = "0 ps",
	parameter c_cnt_in_src_16 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_16 = 0,
	parameter c_cnt_prst_16 = 1,
	parameter cnt_fpll_src_16 = "fpll_0",
	parameter dprio0_cnt_bypass_en_16 = "false",
	parameter dprio0_cnt_hi_div_16 = 1,
	parameter dprio0_cnt_lo_div_16 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_16 = "false",
	parameter dprio1_cnt_bypass_en_16 = dprio0_cnt_bypass_en_16,
	parameter dprio1_cnt_hi_div_16 = dprio0_cnt_hi_div_16,
	parameter dprio1_cnt_lo_div_16 = dprio0_cnt_lo_div_16,
	parameter dprio1_cnt_odd_div_even_duty_en_16 = dprio0_cnt_odd_div_even_duty_en_16,
	
	parameter output_clock_frequency_17 = "0 ps",
	parameter enable_output_counter_17 = "true",
	parameter phase_shift_17 = "0 ps",
	parameter duty_cycle_17 = 50,
	parameter c_cnt_coarse_dly_17 = "0 ps",
	parameter c_cnt_fine_dly_17 = "0 ps",
	parameter c_cnt_in_src_17 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_17 = 0,
	parameter c_cnt_prst_17 = 1,
	parameter cnt_fpll_src_17 = "fpll_0",
	parameter dprio0_cnt_bypass_en_17 = "false",
	parameter dprio0_cnt_hi_div_17 = 1,
	parameter dprio0_cnt_lo_div_17 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_17 = "false",
	parameter dprio1_cnt_bypass_en_17 = dprio0_cnt_bypass_en_17,
	parameter dprio1_cnt_hi_div_17 = dprio0_cnt_hi_div_17,
	parameter dprio1_cnt_lo_div_17 = dprio0_cnt_lo_div_17,
	parameter dprio1_cnt_odd_div_even_duty_en_17 = dprio0_cnt_odd_div_even_duty_en_17,

	// arriav_pll_dpa_output parameters -- dpa_output 0
	parameter dpa_output_clock_frequency_0 = "0 ps",
	parameter pll_vcoph_div_0 = 1,

	parameter dpa_output_clock_frequency_1 = "0 ps",
	parameter pll_vcoph_div_1 = 1,
	
	// arriav_pll_extclk_output parameters -- extclk 0
	parameter enable_extclk_output_0 = "false",
	parameter pll_extclk_cnt_src_0 = "vss",
	parameter pll_extclk_enable_0 = "true",
	parameter pll_extclk_invert_0 = "false",
	
	parameter enable_extclk_output_1 = "false",
	parameter pll_extclk_cnt_src_1 = "vss",
	parameter pll_extclk_enable_1 = "true",
	parameter pll_extclk_invert_1 = "false",
	
	parameter enable_extclk_output_2 = "false",
	parameter pll_extclk_cnt_src_2 = "vss",
	parameter pll_extclk_enable_2 = "true",
	parameter pll_extclk_invert_2 = "false",
	
	parameter enable_extclk_output_3 = "false",
	parameter pll_extclk_cnt_src_3 = "vss",
	parameter pll_extclk_enable_3 = "true",
	parameter pll_extclk_invert_3 = "false",
	
	// arriav_pll_dll_output parameters -- dll_output 0
	parameter enable_dll_output_0 = "false",
	parameter pll_dll_src_value_0 = "vss",
	
	parameter enable_dll_output_1 = "false",
	parameter pll_dll_src_value_1 = "vss",

	// arriav_pll_lvds_output parameters -- lvds_output 0
	parameter enable_lvds_output_0 = "false",
	parameter pll_loaden_coarse_dly_0 = "0 ps",
	parameter pll_loaden_enable_disable_0 = "true",
	parameter pll_loaden_fine_dly_0 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_0 = "0 ps",
	parameter pll_lvdsclk_enable_disable_0 = "true",
	parameter pll_lvdsclk_fine_dly_0 = "0 ps",

	parameter enable_lvds_output_1 = "false",
	parameter pll_loaden_coarse_dly_1 = "0 ps",
	parameter pll_loaden_enable_disable_1 = "true",
	parameter pll_loaden_fine_dly_1 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_1 = "0 ps",
	parameter pll_lvdsclk_enable_disable_1 = "true",
	parameter pll_lvdsclk_fine_dly_1 = "0 ps",

	parameter enable_lvds_output_2 = "false",
	parameter pll_loaden_coarse_dly_2 = "0 ps",
	parameter pll_loaden_enable_disable_2 = "true",
	parameter pll_loaden_fine_dly_2 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_2 = "0 ps",
	parameter pll_lvdsclk_enable_disable_2 = "true",
	parameter pll_lvdsclk_fine_dly_2 = "0 ps",

	parameter enable_lvds_output_3 = "false",
	parameter pll_loaden_coarse_dly_3 = "0 ps",
	parameter pll_loaden_enable_disable_3 = "true",
	parameter pll_loaden_fine_dly_3 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_3 = "0 ps",
	parameter pll_lvdsclk_enable_disable_3 = "true",
	parameter pll_lvdsclk_fine_dly_3 = "0 ps"
)
(
	// arriav_pll_dpa_output pins
	output [7:0] phout_0,
	output [7:0] phout_1,

	// arriav_pll_refclk_select pins
	input [number_of_fplls-1:0] adjpllin,	
	input [number_of_fplls-1:0] cclk,
	input [number_of_fplls-1:0] coreclkin,
	input [number_of_fplls-1:0] extswitch,
	input [number_of_fplls-1:0] iqtxrxclkin,
	input [number_of_fplls-1:0] plliqclkin,
	input [number_of_fplls-1:0] rxiqclkin,
	input [3:0] clkin,
	input [1:0] refiqclk_0,
	input [1:0] refiqclk_1,
	output [number_of_fplls-1:0] clk0bad,
	output [number_of_fplls-1:0] clk1bad,
	output [number_of_fplls-1:0] pllclksel,

// arriav_pll_reconfig pins
	input [number_of_fplls-1:0] atpgmode,
	input [number_of_fplls-1:0] clk,
	input [number_of_fplls-1:0] fpllcsrtest,
	input [number_of_fplls-1:0] iocsrclkin,
	input [number_of_fplls-1:0] iocsrdatain,
	input [number_of_fplls-1:0] iocsren,
	input [number_of_fplls-1:0] iocsrrstn,
	input [number_of_fplls-1:0] mdiodis,
	input [number_of_fplls-1:0] phaseen,
	input [number_of_fplls-1:0] read,
	input [number_of_fplls-1:0] rstn,
	input [number_of_fplls-1:0] scanen,
	input [number_of_fplls-1:0] sershiftload,
	input [number_of_fplls-1:0] shiftdonei,
	input [number_of_fplls-1:0] updn,
	input [number_of_fplls-1:0] write,
	input [5:0] addr_0,
	input [5:0] addr_1,
	input [1:0] byteen_0,
	input [1:0] byteen_1,
	input [4:0] cntsel_0,
	input [4:0] cntsel_1,
	input [15:0] din_0,
	input [15:0] din_1,
	output [number_of_fplls-1:0] blockselect,
	output [number_of_fplls-1:0] iocsrdataout,
	output [number_of_fplls-1:0] iocsrenbuf,
	output [number_of_fplls-1:0] iocsrrstnbuf,
	output [number_of_fplls-1:0] phasedone,
	output [15:0] dout_0,
	output [15:0] dout_1,
	output [815:0] dprioout_0,
	output [815:0] dprioout_1,

// arriav_fractional_pll pins
	input [number_of_fplls-1:0] fbclkfpll,
	input [number_of_fplls-1:0] lvdfbin,
	input [number_of_fplls-1:0] nresync,
	input [number_of_fplls-1:0] pfden,
	input [number_of_fplls-1:0] shiften_fpll,
	input [number_of_fplls-1:0] zdb,
	output [number_of_fplls-1:0] fblvdsout,
	output [number_of_fplls-1:0] lock,
	output [number_of_fplls-1:0] mcntout,
	output [number_of_fplls-1:0] plniotribuf,

// arriav_pll_extclk_output pins
	input [number_of_extclks-1:0] clken,
	output [number_of_extclks-1:0] extclk,

// arriav_pll_dll_output pins
	input [number_of_dlls-1:0] dll_clkin,
	output [number_of_dlls-1:0] clkout,

// arriav_pll_lvds_output pins
	output [number_of_lvds-1:0] loaden,
	output [number_of_lvds-1:0] lvdsclk,

// arriav_pll_output_counter pins
	output [number_of_counters-1:0] divclk,
	output [number_of_counters-1:0] cascade_out	
);

////////////////////////////////////////////////////////////////////////////////
// pll_clkin_0_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLKIN_0_SRC_PLL_IQCLK = 4'b1100 ;
localparam PLL_CLKIN_0_SRC_FPLL = 4'b1011 ;
localparam PLL_CLKIN_0_SRC_IQTXRXCLK = 4'b1010 ;
localparam PLL_CLKIN_0_SRC_CMU_IQCLK = 4'b1001 ;
localparam PLL_CLKIN_0_SRC_VSS = 4'b1000 ;
localparam PLL_CLKIN_0_SRC_CLK_3 = 4'b0111 ;
localparam PLL_CLKIN_0_SRC_CLK_2 = 4'b0110 ;
localparam PLL_CLKIN_0_SRC_CLK_1 = 4'b0101 ;
localparam PLL_CLKIN_0_SRC_CLK_0 = 4'b0100 ;
localparam PLL_CLKIN_0_SRC_REF_CLK1 = 4'b0011 ;
localparam PLL_CLKIN_0_SRC_REF_CLK0 = 4'b0010 ;
localparam PLL_CLKIN_0_SRC_ADJ_PLL_CLK = 4'b0001 ;
localparam PLL_CLKIN_0_SRC_CORE_REF_CLK = 4'b0000 ;
localparam local_pll_clkin_0_src_0 = (pll_clkin_0_src_0 == "core_ref_clk") ? PLL_CLKIN_0_SRC_CORE_REF_CLK :
								   (pll_clkin_0_src_0 == "adj_pll_clk") ? PLL_CLKIN_0_SRC_ADJ_PLL_CLK :
								   (pll_clkin_0_src_0 == "ref_clk0") ? PLL_CLKIN_0_SRC_REF_CLK0 :
								   (pll_clkin_0_src_0 == "ref_clk1") ? PLL_CLKIN_0_SRC_REF_CLK1 :
								   (pll_clkin_0_src_0 == "clk_0") ? PLL_CLKIN_0_SRC_CLK_0 :
								   (pll_clkin_0_src_0 == "clk_1") ? PLL_CLKIN_0_SRC_CLK_1 :
								   (pll_clkin_0_src_0 == "clk_2") ? PLL_CLKIN_0_SRC_CLK_2 :
								   (pll_clkin_0_src_0 == "clk_3") ? PLL_CLKIN_0_SRC_CLK_3 :
								   (pll_clkin_0_src_0 == "vss") ? PLL_CLKIN_0_SRC_VSS :
								   (pll_clkin_0_src_0 == "cmu_iqclk") ? PLL_CLKIN_0_SRC_CMU_IQCLK :
								   (pll_clkin_0_src_0 == "iqtxrxclk") ? PLL_CLKIN_0_SRC_IQTXRXCLK :
								   (pll_clkin_0_src_0 == "fpll") ? PLL_CLKIN_0_SRC_FPLL :
								   (pll_clkin_0_src_0 == "pll_iqclk") ? PLL_CLKIN_0_SRC_PLL_IQCLK : PLL_CLKIN_0_SRC_VSS;
localparam local_pll_clkin_0_src_1 = (pll_clkin_0_src_1 == "core_ref_clk") ? PLL_CLKIN_0_SRC_CORE_REF_CLK :
								   (pll_clkin_0_src_1 == "adj_pll_clk") ? PLL_CLKIN_0_SRC_ADJ_PLL_CLK :
								   (pll_clkin_0_src_1 == "ref_clk0") ? PLL_CLKIN_0_SRC_REF_CLK0 :
								   (pll_clkin_0_src_1 == "ref_clk1") ? PLL_CLKIN_0_SRC_REF_CLK1 :
								   (pll_clkin_0_src_1 == "clk_0") ? PLL_CLKIN_0_SRC_CLK_0 :
								   (pll_clkin_0_src_1 == "clk_1") ? PLL_CLKIN_0_SRC_CLK_1 :
								   (pll_clkin_0_src_1 == "clk_2") ? PLL_CLKIN_0_SRC_CLK_2 :
								   (pll_clkin_0_src_1 == "clk_3") ? PLL_CLKIN_0_SRC_CLK_3 :
								   (pll_clkin_0_src_1 == "vss") ? PLL_CLKIN_0_SRC_VSS :
								   (pll_clkin_0_src_1 == "cmu_iqclk") ? PLL_CLKIN_0_SRC_CMU_IQCLK :
								   (pll_clkin_0_src_1 == "iqtxrxclk") ? PLL_CLKIN_0_SRC_IQTXRXCLK :
								   (pll_clkin_0_src_1 == "fpll") ? PLL_CLKIN_0_SRC_FPLL :
								   (pll_clkin_0_src_1 == "pll_iqclk") ? PLL_CLKIN_0_SRC_PLL_IQCLK : PLL_CLKIN_0_SRC_VSS;

								   
////////////////////////////////////////////////////////////////////////////////
// pll_clkin_1_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLKIN_1_SRC_PLL_IQCLK = 4'b1100 ;
localparam PLL_CLKIN_1_SRC_FPLL = 4'b1011 ;
localparam PLL_CLKIN_1_SRC_IQTXRXCLK = 4'b1010 ;
localparam PLL_CLKIN_1_SRC_CMU_IQCLK = 4'b1001 ;
localparam PLL_CLKIN_1_SRC_VSS = 4'b1000 ;
localparam PLL_CLKIN_1_SRC_CLK_3 = 4'b0111 ;
localparam PLL_CLKIN_1_SRC_CLK_2 = 4'b0110 ;
localparam PLL_CLKIN_1_SRC_CLK_1 = 4'b0101 ;
localparam PLL_CLKIN_1_SRC_CLK_0 = 4'b0100 ;
localparam PLL_CLKIN_1_SRC_REF_CLK1 = 4'b0011 ;
localparam PLL_CLKIN_1_SRC_REF_CLK0 = 4'b0010 ;
localparam PLL_CLKIN_1_SRC_ADJ_PLL_CLK = 4'b0001 ;
localparam PLL_CLKIN_1_SRC_CORE_REF_CLK = 4'b0000 ;
localparam local_pll_clkin_1_src_0 = (pll_clkin_1_src_0 == "core_ref_clk") ? PLL_CLKIN_1_SRC_CORE_REF_CLK :
								   (pll_clkin_1_src_0 == "adj_pll_clk") ? PLL_CLKIN_1_SRC_ADJ_PLL_CLK :
								   (pll_clkin_1_src_0 == "ref_clk0") ? PLL_CLKIN_1_SRC_REF_CLK0 :
								   (pll_clkin_1_src_0 == "ref_clk1") ? PLL_CLKIN_1_SRC_REF_CLK1 :
								   (pll_clkin_1_src_0 == "clk_0") ? PLL_CLKIN_1_SRC_CLK_0 :
								   (pll_clkin_1_src_0 == "clk_1") ? PLL_CLKIN_1_SRC_CLK_1 :
								   (pll_clkin_1_src_0 == "clk_2") ? PLL_CLKIN_1_SRC_CLK_2 :
								   (pll_clkin_1_src_0 == "clk_3") ? PLL_CLKIN_1_SRC_CLK_3 :
								   (pll_clkin_1_src_0 == "vss") ? PLL_CLKIN_1_SRC_VSS :
								   (pll_clkin_1_src_0 == "cmu_iqclk") ? PLL_CLKIN_1_SRC_CMU_IQCLK :
								   (pll_clkin_1_src_0 == "iqtxrxclk") ? PLL_CLKIN_1_SRC_IQTXRXCLK :
								   (pll_clkin_1_src_0 == "fpll") ? PLL_CLKIN_1_SRC_FPLL :
								   (pll_clkin_1_src_0 == "pll_iqclk") ? PLL_CLKIN_1_SRC_PLL_IQCLK : PLL_CLKIN_1_SRC_VSS;
localparam local_pll_clkin_1_src_1 = (pll_clkin_1_src_1 == "core_ref_clk") ? PLL_CLKIN_1_SRC_CORE_REF_CLK :
								   (pll_clkin_1_src_1 == "adj_pll_clk") ? PLL_CLKIN_1_SRC_ADJ_PLL_CLK :
								   (pll_clkin_1_src_1 == "ref_clk0") ? PLL_CLKIN_1_SRC_REF_CLK0 :
								   (pll_clkin_1_src_1 == "ref_clk1") ? PLL_CLKIN_1_SRC_REF_CLK1 :
								   (pll_clkin_1_src_1 == "clk_0") ? PLL_CLKIN_1_SRC_CLK_0 :
								   (pll_clkin_1_src_1 == "clk_1") ? PLL_CLKIN_1_SRC_CLK_1 :
								   (pll_clkin_1_src_1 == "clk_2") ? PLL_CLKIN_1_SRC_CLK_2 :
								   (pll_clkin_1_src_1 == "clk_3") ? PLL_CLKIN_1_SRC_CLK_3 :
								   (pll_clkin_1_src_1 == "vss") ? PLL_CLKIN_1_SRC_VSS :
								   (pll_clkin_1_src_1 == "cmu_iqclk") ? PLL_CLKIN_1_SRC_CMU_IQCLK :
								   (pll_clkin_1_src_1 == "iqtxrxclk") ? PLL_CLKIN_1_SRC_IQTXRXCLK :
								   (pll_clkin_1_src_1 == "fpll") ? PLL_CLKIN_1_SRC_FPLL :
								   (pll_clkin_1_src_1 == "pll_iqclk") ? PLL_CLKIN_1_SRC_PLL_IQCLK : PLL_CLKIN_1_SRC_VSS;
								   
////////////////////////////////////////////////////////////////////////////////
// pll_clk_sw_dly_setting
////////////////////////////////////////////////////////////////////////////////
localparam SWITCHOVER_DLY_SETTING = 3'b000 ;
localparam local_pll_clk_sw_dly_0 = pll_clk_sw_dly_0;
localparam local_pll_clk_sw_dly_1 = pll_clk_sw_dly_1;
localparam local_pll_clk_sw_dly_setting_0 = pll_clk_sw_dly_0;
localparam local_pll_clk_sw_dly_setting_1 = pll_clk_sw_dly_1;

////////////////////////////////////////////////////////////////////////////////
// pll_clk_loss_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLK_LOSS_SW_ENABLED = 1'b1 ;
localparam PLL_CLK_LOSS_SW_BYPS = 1'b0 ;
localparam local_pll_clk_loss_sw_en_0 = (pll_clk_loss_sw_en_0 == "false") ? PLL_CLK_LOSS_SW_BYPS : PLL_CLK_LOSS_SW_ENABLED;
localparam local_pll_clk_loss_sw_en_1 = (pll_clk_loss_sw_en_1 == "false") ? PLL_CLK_LOSS_SW_BYPS : PLL_CLK_LOSS_SW_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_manu_clk_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_MANU_CLK_SW_ENABLED = 1'b1 ;
localparam PLL_MANU_CLK_SW_DISABLED = 1'b0 ;
localparam local_pll_manu_clk_sw_en_0 = (pll_manu_clk_sw_en_0 == "false") ? PLL_MANU_CLK_SW_DISABLED : PLL_MANU_CLK_SW_ENABLED;
localparam local_pll_manu_clk_sw_en_1 = (pll_manu_clk_sw_en_1 == "false") ? PLL_MANU_CLK_SW_DISABLED : PLL_MANU_CLK_SW_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_auto_clk_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_AUTO_CLK_SW_ENABLED = 1'b1 ;
localparam PLL_AUTO_CLK_SW_DISABLED = 1'b0 ;
localparam local_pll_auto_clk_sw_en_0 = (pll_auto_clk_sw_en_0 == "false") ? PLL_AUTO_CLK_SW_DISABLED : PLL_AUTO_CLK_SW_ENABLED; ////////////////////////////////////////////////////////////////////////////////
localparam local_pll_auto_clk_sw_en_1 = (pll_auto_clk_sw_en_1 == "false") ? PLL_AUTO_CLK_SW_DISABLED : PLL_AUTO_CLK_SW_ENABLED; ////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph0_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH0_EN = 1'b1 ;
localparam PLL_VCO_PH0_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph0_en_0 = (pll_vco_ph0_en_0 == "false") ? PLL_VCO_PH0_DIS_EN : PLL_VCO_PH0_EN;
localparam local_pll_vco_ph0_en_1 = (pll_vco_ph0_en_1 == "false") ? PLL_VCO_PH0_DIS_EN : PLL_VCO_PH0_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph1_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH1_EN = 1'b1 ;
localparam PLL_VCO_PH1_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph1_en_0 = (pll_vco_ph1_en_0 == "false") ? PLL_VCO_PH1_DIS_EN : PLL_VCO_PH1_EN;
localparam local_pll_vco_ph1_en_1 = (pll_vco_ph1_en_1 == "false") ? PLL_VCO_PH1_DIS_EN : PLL_VCO_PH1_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph2_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH2_EN = 1'b1 ;
localparam PLL_VCO_PH2_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph2_en_0 = (pll_vco_ph2_en_0 == "false") ? PLL_VCO_PH2_DIS_EN : PLL_VCO_PH2_EN;
localparam local_pll_vco_ph2_en_1 = (pll_vco_ph2_en_1 == "false") ? PLL_VCO_PH2_DIS_EN : PLL_VCO_PH2_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph3_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH3_EN = 1'b1 ;
localparam PLL_VCO_PH3_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph3_en_0 = (pll_vco_ph3_en_0 == "false") ? PLL_VCO_PH3_DIS_EN : PLL_VCO_PH3_EN;
localparam local_pll_vco_ph3_en_1 = (pll_vco_ph3_en_1 == "false") ? PLL_VCO_PH3_DIS_EN : PLL_VCO_PH3_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph4_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH4_EN = 1'b1 ;
localparam PLL_VCO_PH4_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph4_en_0 = (pll_vco_ph4_en_0 == "false") ? PLL_VCO_PH4_DIS_EN : PLL_VCO_PH4_EN;
localparam local_pll_vco_ph4_en_1 = (pll_vco_ph4_en_1 == "false") ? PLL_VCO_PH4_DIS_EN : PLL_VCO_PH4_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph5_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH5_EN = 1'b1 ;
localparam PLL_VCO_PH5_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph5_en_0 = (pll_vco_ph5_en_0 == "false") ? PLL_VCO_PH5_DIS_EN : PLL_VCO_PH5_EN;
localparam local_pll_vco_ph5_en_1 = (pll_vco_ph5_en_1 == "false") ? PLL_VCO_PH5_DIS_EN : PLL_VCO_PH5_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph6_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH6_EN = 1'b1 ;
localparam PLL_VCO_PH6_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph6_en_0 = (pll_vco_ph6_en_0 == "false") ? PLL_VCO_PH6_DIS_EN : PLL_VCO_PH6_EN;
localparam local_pll_vco_ph6_en_1 = (pll_vco_ph6_en_1 == "false") ? PLL_VCO_PH6_DIS_EN : PLL_VCO_PH6_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph7_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH7_EN = 1'b1 ;
localparam PLL_VCO_PH7_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph7_en_0 = (pll_vco_ph7_en_0 == "false") ? PLL_VCO_PH7_DIS_EN : PLL_VCO_PH7_EN;
localparam local_pll_vco_ph7_en_1 = (pll_vco_ph7_en_1 == "false") ? PLL_VCO_PH7_DIS_EN : PLL_VCO_PH7_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_enable
////////////////////////////////////////////////////////////////////////////////
localparam PLL_ENABLED = 1'b1 ;
localparam PLL_DISABLED = 1'b0 ;
localparam local_pll_enable_0 = (pll_enable_0 == "true") ? PLL_ENABLED : PLL_DISABLED;
localparam local_pll_enable_1 = (pll_enable_1 == "true") ? PLL_ENABLED : PLL_DISABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_ctrl_override_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CTRL_ENABLE = 1'b1 ;
localparam PLL_CTRL_DISABLE = 1'b0 ;
localparam local_pll_ctrl_override_setting_0 = (pll_ctrl_override_setting_0 == "false") ? PLL_CTRL_DISABLE : PLL_CTRL_ENABLE;
localparam local_pll_ctrl_override_setting_1 = (pll_ctrl_override_setting_1 == "false") ? PLL_CTRL_DISABLE : PLL_CTRL_ENABLE;

////////////////////////////////////////////////////////////////////////////////
// pll_fbclk_mux_1
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FBCLK_MUX_1_FBCLK_FPLL = 2'b11 ;
localparam PLL_FBCLK_MUX_1_LVDS = 2'b10 ;
localparam PLL_FBCLK_MUX_1_ZBD = 2'b01 ;
localparam PLL_FBCLK_MUX_1_GLB = 2'b00 ;
localparam local_pll_fbclk_mux_1_0 = (pll_fbclk_mux_1_0 == "glb") ? PLL_FBCLK_MUX_1_GLB :
								   (pll_fbclk_mux_1_0 == "zbd") ? PLL_FBCLK_MUX_1_ZBD :
								   (pll_fbclk_mux_1_0 == "lvds") ? PLL_FBCLK_MUX_1_LVDS : PLL_FBCLK_MUX_1_FBCLK_FPLL;
localparam local_pll_fbclk_mux_1_1 = (pll_fbclk_mux_1_1 == "glb") ? PLL_FBCLK_MUX_1_GLB :
								   (pll_fbclk_mux_1_1 == "zbd") ? PLL_FBCLK_MUX_1_ZBD :
								   (pll_fbclk_mux_1_1 == "lvds") ? PLL_FBCLK_MUX_1_LVDS : PLL_FBCLK_MUX_1_FBCLK_FPLL;

////////////////////////////////////////////////////////////////////////////////
// pll_fbclk_mux_2
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FBCLK_MUX_2_M_CNT = 1'b1 ;
localparam PLL_FBCLK_MUX_2_FB_1 = 1'b0 ;
localparam local_pll_fbclk_mux_2_0 = (pll_fbclk_mux_2_0 == "fb_1") ? PLL_FBCLK_MUX_2_FB_1 : PLL_FBCLK_MUX_2_M_CNT;
localparam local_pll_fbclk_mux_2_1 = (pll_fbclk_mux_2_1 == "fb_1") ? PLL_FBCLK_MUX_2_FB_1 : PLL_FBCLK_MUX_2_M_CNT;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_BYPASS_ENABLED = 1'b1 ;
localparam PLL_N_CNT_DIV_ENABLED = 1'b0 ;
localparam local_pll_n_cnt_bypass_en_0 = (pll_n_cnt_bypass_en_0 == "false") ? PLL_N_CNT_DIV_ENABLED : PLL_N_CNT_BYPASS_ENABLED;
localparam local_pll_n_cnt_bypass_en_1 = (pll_n_cnt_bypass_en_1 == "false") ? PLL_N_CNT_DIV_ENABLED : PLL_N_CNT_BYPASS_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_lo_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_LO_VALUE = 8'h01 ;
localparam local_pll_n_cnt_lo_div_0 = pll_n_cnt_lo_div_0;
localparam local_pll_n_cnt_lo_div_setting_0 = pll_n_cnt_lo_div_0;
localparam local_pll_n_cnt_lo_div_1 = pll_n_cnt_lo_div_1;
localparam local_pll_n_cnt_lo_div_setting_1 = pll_n_cnt_lo_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_hi_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_HI_VALUE = 8'h01 ;
localparam local_pll_n_cnt_hi_div_0 = pll_n_cnt_hi_div_0;
localparam local_pll_n_cnt_hi_div_setting_0 = pll_n_cnt_hi_div_0;
localparam local_pll_n_cnt_hi_div_1 = pll_n_cnt_hi_div_1;
localparam local_pll_n_cnt_hi_div_setting_1 = pll_n_cnt_hi_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_odd_div_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_EVEN_DUTY_ENABLED = 1'b1 ;
localparam PLL_N_CNT_EVEN_DUTY_DISABLED = 1'b0 ;
localparam local_pll_n_cnt_odd_div_duty_en_0 = (pll_n_cnt_odd_div_duty_en_0 == "false") ? PLL_N_CNT_EVEN_DUTY_DISABLED : PLL_N_CNT_EVEN_DUTY_ENABLED;
localparam local_pll_n_cnt_odd_div_duty_en_1 = (pll_n_cnt_odd_div_duty_en_1 == "false") ? PLL_N_CNT_EVEN_DUTY_DISABLED : PLL_N_CNT_EVEN_DUTY_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_tclk_sel
////////////////////////////////////////////////////////////////////////////////
localparam PLL_TCLK_M_SRC = 1'b1 ;
localparam PLL_TCLK_N_SRC = 1'b0 ;
localparam local_pll_tclk_sel_0 = (pll_tclk_sel_0 == "cdb_pll_tclk_sel_m_src") ? PLL_TCLK_M_SRC : PLL_TCLK_N_SRC;
localparam local_pll_tclk_sel_1 = (pll_tclk_sel_1 == "cdb_pll_tclk_sel_m_src") ? PLL_TCLK_M_SRC : PLL_TCLK_N_SRC;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_odd_div_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_EVEN_DUTY_ENABLED = 1'b1 ;
localparam PLL_M_CNT_EVEN_DUTY_DISABLED = 1'b0 ;
localparam local_pll_m_cnt_odd_div_duty_en_0 = (pll_m_cnt_odd_div_duty_en_0 == "false") ? PLL_M_CNT_EVEN_DUTY_DISABLED : PLL_M_CNT_EVEN_DUTY_ENABLED;
localparam local_pll_m_cnt_odd_div_duty_en_1 = (pll_m_cnt_odd_div_duty_en_1 == "false") ? PLL_M_CNT_EVEN_DUTY_DISABLED : PLL_M_CNT_EVEN_DUTY_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_BYPASS_ENABLED = 1'b1 ;
localparam PLL_M_CNT_DIV_ENABLED = 1'b0 ;
localparam local_pll_m_cnt_bypass_en_0 = (pll_m_cnt_bypass_en_0 == "false") ? PLL_M_CNT_DIV_ENABLED : PLL_M_CNT_BYPASS_ENABLED;
localparam local_pll_m_cnt_bypass_en_1 = (pll_m_cnt_bypass_en_1 == "false") ? PLL_M_CNT_DIV_ENABLED : PLL_M_CNT_BYPASS_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_hi_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_HI_VALUE = 8'h01 ;
localparam local_pll_m_cnt_hi_div_0 = pll_m_cnt_hi_div_0;
localparam local_pll_m_cnt_hi_div_setting_0 = pll_m_cnt_hi_div_0;
localparam local_pll_m_cnt_hi_div_1 = pll_m_cnt_hi_div_1;
localparam local_pll_m_cnt_hi_div_setting_1 = pll_m_cnt_hi_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_in_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_IN_SRC_VSS = 2'b11 ;
localparam PLL_M_CNT_IN_SRC_TEST_CLK = 2'b10 ;
localparam PLL_M_CNT_IN_SRC_FBLVDS = 2'b01 ;
localparam PLL_M_CNT_IN_SRC_PH_MUX_CLK = 2'b00 ;
localparam local_pll_m_cnt_in_src_0 = (pll_m_cnt_in_src_0 == "ph_mux_clk") ? PLL_M_CNT_IN_SRC_PH_MUX_CLK :
									(pll_m_cnt_in_src_0 == "fblvds") ? PLL_M_CNT_IN_SRC_FBLVDS :
									(pll_m_cnt_in_src_0 == "test_clk") ? PLL_M_CNT_IN_SRC_TEST_CLK : PLL_M_CNT_IN_SRC_VSS;
localparam local_pll_m_cnt_in_src_1 = (pll_m_cnt_in_src_1 == "ph_mux_clk") ? PLL_M_CNT_IN_SRC_PH_MUX_CLK :
									(pll_m_cnt_in_src_1 == "fblvds") ? PLL_M_CNT_IN_SRC_FBLVDS :
									(pll_m_cnt_in_src_1 == "test_clk") ? PLL_M_CNT_IN_SRC_TEST_CLK : PLL_M_CNT_IN_SRC_VSS;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_lo_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_LO_VALUE = 8'h01 ;
localparam local_pll_m_cnt_lo_div_0 = pll_m_cnt_lo_div_0;
localparam local_pll_m_cnt_lo_div_setting_0 = pll_m_cnt_lo_div_0;
localparam local_pll_m_cnt_lo_div_1 = pll_m_cnt_lo_div_1;
localparam local_pll_m_cnt_lo_div_setting_1 = pll_m_cnt_lo_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_prst_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_PRST_VALUE = 8'h01 ;
localparam local_pll_m_cnt_prst_0 = pll_m_cnt_prst_0;
localparam local_pll_m_cnt_prst_setting_0 = pll_m_cnt_prst_0;
localparam local_pll_m_cnt_prst_1 = pll_m_cnt_prst_1;
localparam local_pll_m_cnt_prst_setting_1 = pll_m_cnt_prst_1;

////////////////////////////////////////////////////////////////////////////////
// pll_unlock_fltr_cfg_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_UNLOCK_COUNTER_SETTING = 3'b000 ;
localparam local_pll_unlock_fltr_cfg_0 = pll_unlock_fltr_cfg_0;
localparam local_pll_unlock_fltr_cfg_setting_0 = pll_unlock_fltr_cfg_0;
localparam local_pll_unlock_fltr_cfg_1 = pll_unlock_fltr_cfg_1;
localparam local_pll_unlock_fltr_cfg_setting_1 = pll_unlock_fltr_cfg_1;

////////////////////////////////////////////////////////////////////////////////
// pll_lock_fltr_cfg_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_LOCK_COUNTER_SETTING = 12'h001 ;
localparam local_pll_lock_fltr_cfg_0 = pll_lock_fltr_cfg_0;
localparam local_pll_lock_fltr_cfg_setting_0 = pll_lock_fltr_cfg_0;
localparam local_pll_lock_fltr_cfg_1 = pll_lock_fltr_cfg_1;
localparam local_pll_lock_fltr_cfg_setting_1 = pll_lock_fltr_cfg_1;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_in_src
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_IN_SRC_TEST_CLK1 = 2'b11 ;
localparam C_CNT_IN_SRC_TEST_CLK0 = 2'b10 ;
localparam C_CNT_IN_SRC_CSCD_CLK = 2'b01 ;
localparam C_CNT_IN_SRC_PH_MUX_CLK = 2'b00 ;
localparam local_c_cnt_in_src_0 = (c_cnt_in_src_0 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_0 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_0 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_1 = (c_cnt_in_src_1 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_1 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_1 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_2 = (c_cnt_in_src_2 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_2 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_2 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_3 = (c_cnt_in_src_3 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_3 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_3 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_4 = (c_cnt_in_src_4 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_4 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_4 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_5 = (c_cnt_in_src_5 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_5 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_5 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_6 = (c_cnt_in_src_6 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_6 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_6 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_7 = (c_cnt_in_src_7 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_7 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_7 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_8 = (c_cnt_in_src_8 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_8 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_8 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_9 = (c_cnt_in_src_9 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_9 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_9 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_10 = (c_cnt_in_src_10 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_10 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_10 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_11 = (c_cnt_in_src_11 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_11 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_11 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_12 = (c_cnt_in_src_12 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_12 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_12 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_13 = (c_cnt_in_src_13 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_13 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_13 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_14 = (c_cnt_in_src_14 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_14 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_14 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_15 = (c_cnt_in_src_15 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_15 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_15 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_16 = (c_cnt_in_src_16 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_16 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_16 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_17 = (c_cnt_in_src_17 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_17 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_17 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;

////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_DIV_ENABLED = 0 ;
localparam local_dprio0_cnt_bypass_en_0 = (dprio0_cnt_bypass_en_0 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_0 = (dprio0_cnt_bypass_en_0 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_1 = (dprio0_cnt_bypass_en_1 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_1 = (dprio0_cnt_bypass_en_1 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_2 = (dprio0_cnt_bypass_en_2 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_2 = (dprio0_cnt_bypass_en_2 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_3 = (dprio0_cnt_bypass_en_3 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_3 = (dprio0_cnt_bypass_en_3 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_4 = (dprio0_cnt_bypass_en_4 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_4 = (dprio0_cnt_bypass_en_4 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_5 = (dprio0_cnt_bypass_en_5 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_5 = (dprio0_cnt_bypass_en_5 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_6 = (dprio0_cnt_bypass_en_6 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_6 = (dprio0_cnt_bypass_en_6 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_7 = (dprio0_cnt_bypass_en_7 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_7 = (dprio0_cnt_bypass_en_7 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_8 = (dprio0_cnt_bypass_en_8 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_8 = (dprio0_cnt_bypass_en_8 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_9 = (dprio0_cnt_bypass_en_9 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_9 = (dprio0_cnt_bypass_en_9 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_10 = (dprio0_cnt_bypass_en_10 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_10 = (dprio0_cnt_bypass_en_10 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_11 = (dprio0_cnt_bypass_en_11 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_11 = (dprio0_cnt_bypass_en_11 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_12 = (dprio0_cnt_bypass_en_12 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_12 = (dprio0_cnt_bypass_en_12 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_13 = (dprio0_cnt_bypass_en_13 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_13 = (dprio0_cnt_bypass_en_13 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_14 = (dprio0_cnt_bypass_en_14 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_14 = (dprio0_cnt_bypass_en_14 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_15 = (dprio0_cnt_bypass_en_15 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_15 = (dprio0_cnt_bypass_en_15 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_16 = (dprio0_cnt_bypass_en_16 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_16 = (dprio0_cnt_bypass_en_16 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_17 = (dprio0_cnt_bypass_en_17 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_17 = (dprio0_cnt_bypass_en_17 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_prst
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_PRST_VALUE = 1 ;
localparam local_c_cnt_prst_0 = c_cnt_prst_0;
localparam local_c_cnt_prst_user_0 = c_cnt_prst_0;
localparam local_c_cnt_prst_1 = c_cnt_prst_1;
localparam local_c_cnt_prst_user_1 = c_cnt_prst_1;
localparam local_c_cnt_prst_2 = c_cnt_prst_2;
localparam local_c_cnt_prst_user_2 = c_cnt_prst_2;
localparam local_c_cnt_prst_3 = c_cnt_prst_3;
localparam local_c_cnt_prst_user_3 = c_cnt_prst_3;
localparam local_c_cnt_prst_4 = c_cnt_prst_4;
localparam local_c_cnt_prst_user_4 = c_cnt_prst_4;
localparam local_c_cnt_prst_5 = c_cnt_prst_5;
localparam local_c_cnt_prst_user_5 = c_cnt_prst_5;
localparam local_c_cnt_prst_6 = c_cnt_prst_6;
localparam local_c_cnt_prst_user_6 = c_cnt_prst_6;
localparam local_c_cnt_prst_7 = c_cnt_prst_7;
localparam local_c_cnt_prst_user_7 = c_cnt_prst_7;
localparam local_c_cnt_prst_8 = c_cnt_prst_8;
localparam local_c_cnt_prst_user_8 = c_cnt_prst_8;
localparam local_c_cnt_prst_9 = c_cnt_prst_9;
localparam local_c_cnt_prst_user_9 = c_cnt_prst_9;
localparam local_c_cnt_prst_10 = c_cnt_prst_10;
localparam local_c_cnt_prst_user_10 = c_cnt_prst_10;
localparam local_c_cnt_prst_11 = c_cnt_prst_11;
localparam local_c_cnt_prst_user_11 = c_cnt_prst_11;
localparam local_c_cnt_prst_12 = c_cnt_prst_12;
localparam local_c_cnt_prst_user_12 = c_cnt_prst_12;
localparam local_c_cnt_prst_13 = c_cnt_prst_13;
localparam local_c_cnt_prst_user_13 = c_cnt_prst_13;
localparam local_c_cnt_prst_14 = c_cnt_prst_14;
localparam local_c_cnt_prst_user_14 = c_cnt_prst_14;
localparam local_c_cnt_prst_15 = c_cnt_prst_15;
localparam local_c_cnt_prst_user_15 = c_cnt_prst_15;
localparam local_c_cnt_prst_16 = c_cnt_prst_16;
localparam local_c_cnt_prst_user_16 = c_cnt_prst_16;
localparam local_c_cnt_prst_17 = c_cnt_prst_17;
localparam local_c_cnt_prst_user_17 = c_cnt_prst_17;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_ph_mux_prst
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_PH_MUX_PRST_VALUE = 0 ;
localparam local_c_cnt_ph_mux_prst_0 = c_cnt_ph_mux_prst_0;
localparam local_c_cnt_ph_mux_prst_user_0 = c_cnt_ph_mux_prst_0;
localparam local_c_cnt_ph_mux_prst_1 = c_cnt_ph_mux_prst_1;
localparam local_c_cnt_ph_mux_prst_user_1 = c_cnt_ph_mux_prst_1;
localparam local_c_cnt_ph_mux_prst_2 = c_cnt_ph_mux_prst_2;
localparam local_c_cnt_ph_mux_prst_user_2 = c_cnt_ph_mux_prst_2;
localparam local_c_cnt_ph_mux_prst_3 = c_cnt_ph_mux_prst_3;
localparam local_c_cnt_ph_mux_prst_user_3 = c_cnt_ph_mux_prst_3;
localparam local_c_cnt_ph_mux_prst_4 = c_cnt_ph_mux_prst_4;
localparam local_c_cnt_ph_mux_prst_user_4 = c_cnt_ph_mux_prst_4;
localparam local_c_cnt_ph_mux_prst_5 = c_cnt_ph_mux_prst_5;
localparam local_c_cnt_ph_mux_prst_user_5 = c_cnt_ph_mux_prst_5;
localparam local_c_cnt_ph_mux_prst_6 = c_cnt_ph_mux_prst_6;
localparam local_c_cnt_ph_mux_prst_user_6 = c_cnt_ph_mux_prst_6;
localparam local_c_cnt_ph_mux_prst_7 = c_cnt_ph_mux_prst_7;
localparam local_c_cnt_ph_mux_prst_user_7 = c_cnt_ph_mux_prst_7;
localparam local_c_cnt_ph_mux_prst_8 = c_cnt_ph_mux_prst_8;
localparam local_c_cnt_ph_mux_prst_user_8 = c_cnt_ph_mux_prst_8;
localparam local_c_cnt_ph_mux_prst_9 = c_cnt_ph_mux_prst_9;
localparam local_c_cnt_ph_mux_prst_user_9 = c_cnt_ph_mux_prst_9;
localparam local_c_cnt_ph_mux_prst_10 = c_cnt_ph_mux_prst_10;
localparam local_c_cnt_ph_mux_prst_user_10 = c_cnt_ph_mux_prst_10;
localparam local_c_cnt_ph_mux_prst_11 = c_cnt_ph_mux_prst_11;
localparam local_c_cnt_ph_mux_prst_user_11 = c_cnt_ph_mux_prst_11;
localparam local_c_cnt_ph_mux_prst_12 = c_cnt_ph_mux_prst_12;
localparam local_c_cnt_ph_mux_prst_user_12 = c_cnt_ph_mux_prst_12;
localparam local_c_cnt_ph_mux_prst_13 = c_cnt_ph_mux_prst_13;
localparam local_c_cnt_ph_mux_prst_user_13 = c_cnt_ph_mux_prst_13;
localparam local_c_cnt_ph_mux_prst_14 = c_cnt_ph_mux_prst_14;
localparam local_c_cnt_ph_mux_prst_user_14 = c_cnt_ph_mux_prst_14;
localparam local_c_cnt_ph_mux_prst_15 = c_cnt_ph_mux_prst_15;
localparam local_c_cnt_ph_mux_prst_user_15 = c_cnt_ph_mux_prst_15;
localparam local_c_cnt_ph_mux_prst_16 = c_cnt_ph_mux_prst_16;
localparam local_c_cnt_ph_mux_prst_user_16 = c_cnt_ph_mux_prst_16;
localparam local_c_cnt_ph_mux_prst_17 = c_cnt_ph_mux_prst_17;
localparam local_c_cnt_ph_mux_prst_user_17 = c_cnt_ph_mux_prst_17;

/////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_hi_div
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_HI_DIV_VALUE = 0 ;
localparam local_dprio0_cnt_hi_div_0 = dprio0_cnt_hi_div_0;
localparam local_dprio0_cnt_hi_div_user_0 = dprio0_cnt_hi_div_0;
localparam local_dprio0_cnt_hi_div_1 = dprio0_cnt_hi_div_1;
localparam local_dprio0_cnt_hi_div_user_1 = dprio0_cnt_hi_div_1;
localparam local_dprio0_cnt_hi_div_2 = dprio0_cnt_hi_div_2;
localparam local_dprio0_cnt_hi_div_user_2 = dprio0_cnt_hi_div_2;
localparam local_dprio0_cnt_hi_div_3 = dprio0_cnt_hi_div_3;
localparam local_dprio0_cnt_hi_div_user_3 = dprio0_cnt_hi_div_3;
localparam local_dprio0_cnt_hi_div_4 = dprio0_cnt_hi_div_4;
localparam local_dprio0_cnt_hi_div_user_4 = dprio0_cnt_hi_div_4;
localparam local_dprio0_cnt_hi_div_5 = dprio0_cnt_hi_div_5;
localparam local_dprio0_cnt_hi_div_user_5 = dprio0_cnt_hi_div_5;
localparam local_dprio0_cnt_hi_div_6 = dprio0_cnt_hi_div_6;
localparam local_dprio0_cnt_hi_div_user_6 = dprio0_cnt_hi_div_6;
localparam local_dprio0_cnt_hi_div_7 = dprio0_cnt_hi_div_7;
localparam local_dprio0_cnt_hi_div_user_7 = dprio0_cnt_hi_div_7;
localparam local_dprio0_cnt_hi_div_8 = dprio0_cnt_hi_div_8;
localparam local_dprio0_cnt_hi_div_user_8 = dprio0_cnt_hi_div_8;
localparam local_dprio0_cnt_hi_div_9 = dprio0_cnt_hi_div_9;
localparam local_dprio0_cnt_hi_div_user_9 = dprio0_cnt_hi_div_9;
localparam local_dprio0_cnt_hi_div_10 = dprio0_cnt_hi_div_10;
localparam local_dprio0_cnt_hi_div_user_10 = dprio0_cnt_hi_div_10;
localparam local_dprio0_cnt_hi_div_11 = dprio0_cnt_hi_div_11;
localparam local_dprio0_cnt_hi_div_user_11 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_12 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_user_12 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_13 = dprio0_cnt_hi_div_13;
localparam local_dprio0_cnt_hi_div_user_13 = dprio0_cnt_hi_div_13;
localparam local_dprio0_cnt_hi_div_14 = dprio0_cnt_hi_div_14;
localparam local_dprio0_cnt_hi_div_user_14 = dprio0_cnt_hi_div_14;
localparam local_dprio0_cnt_hi_div_15 = dprio0_cnt_hi_div_15;
localparam local_dprio0_cnt_hi_div_user_15 = dprio0_cnt_hi_div_15;
localparam local_dprio0_cnt_hi_div_16 = dprio0_cnt_hi_div_16;
localparam local_dprio0_cnt_hi_div_user_16 = dprio0_cnt_hi_div_16;
localparam local_dprio0_cnt_hi_div_17 = dprio0_cnt_hi_div_17;
localparam local_dprio0_cnt_hi_div_user_17 = dprio0_cnt_hi_div_17;

///////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_lo_div
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_LO_DIV_VALUE = 0 ;
localparam local_dprio0_cnt_lo_div_0 = dprio0_cnt_lo_div_0;
localparam local_dprio0_cnt_lo_div_user_0 = dprio0_cnt_lo_div_0;
localparam local_dprio0_cnt_lo_div_1 = dprio0_cnt_lo_div_1;
localparam local_dprio0_cnt_lo_div_user_1 = dprio0_cnt_lo_div_1;
localparam local_dprio0_cnt_lo_div_2 = dprio0_cnt_lo_div_2;
localparam local_dprio0_cnt_lo_div_user_2 = dprio0_cnt_lo_div_2;
localparam local_dprio0_cnt_lo_div_3 = dprio0_cnt_lo_div_3;
localparam local_dprio0_cnt_lo_div_user_3 = dprio0_cnt_lo_div_3;
localparam local_dprio0_cnt_lo_div_4 = dprio0_cnt_lo_div_4;
localparam local_dprio0_cnt_lo_div_user_4 = dprio0_cnt_lo_div_4;
localparam local_dprio0_cnt_lo_div_5 = dprio0_cnt_lo_div_5;
localparam local_dprio0_cnt_lo_div_user_5 = dprio0_cnt_lo_div_5;
localparam local_dprio0_cnt_lo_div_6 = dprio0_cnt_lo_div_6;
localparam local_dprio0_cnt_lo_div_user_6 = dprio0_cnt_lo_div_6;
localparam local_dprio0_cnt_lo_div_7 = dprio0_cnt_lo_div_7;
localparam local_dprio0_cnt_lo_div_user_7 = dprio0_cnt_lo_div_7;
localparam local_dprio0_cnt_lo_div_8 = dprio0_cnt_lo_div_8;
localparam local_dprio0_cnt_lo_div_user_8 = dprio0_cnt_lo_div_8;
localparam local_dprio0_cnt_lo_div_9 = dprio0_cnt_lo_div_9;
localparam local_dprio0_cnt_lo_div_user_9 = dprio0_cnt_lo_div_9;
localparam local_dprio0_cnt_lo_div_10 = dprio0_cnt_lo_div_10;
localparam local_dprio0_cnt_lo_div_user_10 = dprio0_cnt_lo_div_10;
localparam local_dprio0_cnt_lo_div_11 = dprio0_cnt_lo_div_11;
localparam local_dprio0_cnt_lo_div_user_11 = dprio0_cnt_lo_div_11;
localparam local_dprio0_cnt_lo_div_12 = dprio0_cnt_lo_div_12;
localparam local_dprio0_cnt_lo_div_user_12 = dprio0_cnt_lo_div_12;
localparam local_dprio0_cnt_lo_div_13 = dprio0_cnt_lo_div_13;
localparam local_dprio0_cnt_lo_div_user_13 = dprio0_cnt_lo_div_13;
localparam local_dprio0_cnt_lo_div_14 = dprio0_cnt_lo_div_14;
localparam local_dprio0_cnt_lo_div_user_14 = dprio0_cnt_lo_div_14;
localparam local_dprio0_cnt_lo_div_15 = dprio0_cnt_lo_div_15;
localparam local_dprio0_cnt_lo_div_user_15 = dprio0_cnt_lo_div_15;
localparam local_dprio0_cnt_lo_div_16 = dprio0_cnt_lo_div_16;
localparam local_dprio0_cnt_lo_div_user_16 = dprio0_cnt_lo_div_16;
localparam local_dprio0_cnt_lo_div_17 = dprio0_cnt_lo_div_17;
localparam local_dprio0_cnt_lo_div_user_17 = dprio0_cnt_lo_div_17;

////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_odd_div_even_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED = 0 ;
localparam local_dprio0_cnt_odd_div_even_duty_en_0 = (dprio0_cnt_odd_div_even_duty_en_0 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_0 = (dprio0_cnt_odd_div_even_duty_en_0 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_1 = (dprio0_cnt_odd_div_even_duty_en_1 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_1 = (dprio0_cnt_odd_div_even_duty_en_1 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_2 = (dprio0_cnt_odd_div_even_duty_en_2 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_2 = (dprio0_cnt_odd_div_even_duty_en_2 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_3 = (dprio0_cnt_odd_div_even_duty_en_3 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_3 = (dprio0_cnt_odd_div_even_duty_en_3 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_4 = (dprio0_cnt_odd_div_even_duty_en_4 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_4 = (dprio0_cnt_odd_div_even_duty_en_4 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_5 = (dprio0_cnt_odd_div_even_duty_en_5 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_5 = (dprio0_cnt_odd_div_even_duty_en_5 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_6 = (dprio0_cnt_odd_div_even_duty_en_6 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_6 = (dprio0_cnt_odd_div_even_duty_en_6 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_7 = (dprio0_cnt_odd_div_even_duty_en_7 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_7 = (dprio0_cnt_odd_div_even_duty_en_7 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_8 = (dprio0_cnt_odd_div_even_duty_en_8 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_8 = (dprio0_cnt_odd_div_even_duty_en_8 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_9 = (dprio0_cnt_odd_div_even_duty_en_9 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_9 = (dprio0_cnt_odd_div_even_duty_en_9 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_10 = (dprio0_cnt_odd_div_even_duty_en_10 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_10 = (dprio0_cnt_odd_div_even_duty_en_10 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_11 = (dprio0_cnt_odd_div_even_duty_en_11 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_11 = (dprio0_cnt_odd_div_even_duty_en_11 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_12 = (dprio0_cnt_odd_div_even_duty_en_12 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_12 = (dprio0_cnt_odd_div_even_duty_en_12 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_13 = (dprio0_cnt_odd_div_even_duty_en_13 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_13 = (dprio0_cnt_odd_div_even_duty_en_13 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_14 = (dprio0_cnt_odd_div_even_duty_en_14 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_14 = (dprio0_cnt_odd_div_even_duty_en_14 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_15 = (dprio0_cnt_odd_div_even_duty_en_15 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_15 = (dprio0_cnt_odd_div_even_duty_en_15 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_16 = (dprio0_cnt_odd_div_even_duty_en_16 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_16 = (dprio0_cnt_odd_div_even_duty_en_16 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_17 = (dprio0_cnt_odd_div_even_duty_en_17 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_17 = (dprio0_cnt_odd_div_even_duty_en_17 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;



////////////////////////////////////////////////////////////////////////////////
// pll_bwctrl
////////////////////////////////////////////////////////////////////////////////
localparam PLL_BW_RES_UNUSED5 = 4'b1111 ;
localparam PLL_BW_RES_UNUSED4 = 4'b1110 ;
localparam PLL_BW_RES_UNUSED3 = 4'b1101 ;
localparam PLL_BW_RES_UNUSED2 = 4'b1100 ;
localparam PLL_BW_RES_UNUSED1 = 4'b1011 ;
localparam PLL_BW_RES_0P5K = 4'b1010 ;
localparam PLL_BW_RES_1K = 4'b1001 ;
localparam PLL_BW_RES_2K = 4'b1000 ;
localparam PLL_BW_RES_4K = 4'b0111 ;
localparam PLL_BW_RES_6K = 4'b0110 ;
localparam PLL_BW_RES_8K = 4'b0101 ;
localparam PLL_BW_RES_10K = 4'b0100 ;
localparam PLL_BW_RES_12K = 4'b0011 ;
localparam PLL_BW_RES_14K = 4'b0010 ;
localparam PLL_BW_RES_16K = 4'b0001 ;
localparam PLL_BW_RES_18K = 4'b0000 ;
localparam local_pll_bwctrl_0 = (pll_bwctrl_0 == 18000) ? PLL_BW_RES_18K :
							  (pll_bwctrl_0 == 16000) ? PLL_BW_RES_16K :
							  (pll_bwctrl_0 == 14000) ? PLL_BW_RES_14K :
							  (pll_bwctrl_0 == 12000) ? PLL_BW_RES_12K :
							  (pll_bwctrl_0 == 10000) ? PLL_BW_RES_10K :
							  (pll_bwctrl_0 == 8000) ? PLL_BW_RES_8K :
							  (pll_bwctrl_0 == 6000) ? PLL_BW_RES_6K :
							  (pll_bwctrl_0 == 4000) ? PLL_BW_RES_4K :
							  (pll_bwctrl_0 == 2000) ? PLL_BW_RES_2K :
							  (pll_bwctrl_0 == 1000) ? PLL_BW_RES_1K : 
							  (pll_bwctrl_0 == 500) ? PLL_BW_RES_0P5K : PLL_BW_RES_UNUSED1;
localparam local_pll_bwctrl_1 = (pll_bwctrl_1 == 18000) ? PLL_BW_RES_18K :
							  (pll_bwctrl_1 == 16000) ? PLL_BW_RES_16K :
							  (pll_bwctrl_1 == 14000) ? PLL_BW_RES_14K :
							  (pll_bwctrl_1 == 12000) ? PLL_BW_RES_12K :
							  (pll_bwctrl_1 == 10000) ? PLL_BW_RES_10K :
							  (pll_bwctrl_1 == 8000) ? PLL_BW_RES_8K :
							  (pll_bwctrl_1 == 6000) ? PLL_BW_RES_6K :
							  (pll_bwctrl_1 == 4000) ? PLL_BW_RES_4K :
							  (pll_bwctrl_1 == 2000) ? PLL_BW_RES_2K :
							  (pll_bwctrl_1 == 1000) ? PLL_BW_RES_1K : 
							  (pll_bwctrl_1 == 500) ? PLL_BW_RES_0P5K : PLL_BW_RES_UNUSED1;

////////////////////////////////////////////////////////////////////////////////
// pll_cp_current
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CP_UNUSED3 = 3'b111 ;
localparam PLL_CP_UNUSED2 = 3'b110 ;
localparam PLL_CP_UNUSED1 = 3'b101 ;
localparam PLL_CP_40UA = 3'b100 ;
localparam PLL_CP_30UA = 3'b011 ;
localparam PLL_CP_20UA = 3'b010 ;
localparam PLL_CP_10UA = 3'b001 ;
localparam PLL_CP_5UA = 3'b000 ;
localparam local_pll_cp_current_0 = (pll_cp_current_0 == 5) ? PLL_CP_5UA :
								  (pll_cp_current_0 == 10) ? PLL_CP_10UA :
								  (pll_cp_current_0 == 20) ? PLL_CP_20UA :
								  (pll_cp_current_0 == 30) ? PLL_CP_30UA :
								  (pll_cp_current_0 == 40) ? PLL_CP_40UA : PLL_CP_UNUSED1;
localparam local_pll_cp_current_1 = (pll_cp_current_1 == 5) ? PLL_CP_5UA :
								  (pll_cp_current_1 == 10) ? PLL_CP_10UA :
								  (pll_cp_current_1 == 20) ? PLL_CP_20UA :
								  (pll_cp_current_1 == 30) ? PLL_CP_30UA :
								  (pll_cp_current_1 == 40) ? PLL_CP_40UA : PLL_CP_UNUSED1;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_div
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_DIV_1300 = 1'b1 ;
localparam PLL_VCO_DIV_600 = 1'b0 ;
localparam local_pll_vco_div_0 = (pll_vco_div_0 == 1) ? PLL_VCO_DIV_600 : PLL_VCO_DIV_1300;
localparam local_pll_vco_div_1 = (pll_vco_div_1 == 1) ? PLL_VCO_DIV_600 : PLL_VCO_DIV_1300;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_division_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FRACTIONAL_DIVIDE_VALUE = 32'h00000000 ;
localparam local_pll_fractional_division_0 = pll_fractional_division_0;
localparam local_pll_fractional_division_setting_0 = pll_fractional_division_0;
localparam local_pll_fractional_division_1 = pll_fractional_division_1;
localparam local_pll_fractional_division_setting_1 = pll_fractional_division_1;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_value_ready
////////////////////////////////////////////////////////////////////////////////
localparam PLL_K_READY = 1'b1 ;
localparam PLL_K_NOT_READY = 1'b0 ;
localparam local_pll_fractional_value_ready_0 = (pll_fractional_value_ready_0 == "true") ? PLL_K_READY : PLL_K_NOT_READY;
localparam local_pll_fractional_value_ready_1 = (pll_fractional_value_ready_1 == "true") ? PLL_K_READY : PLL_K_NOT_READY;

////////////////////////////////////////////////////////////////////////////////
// pll_dsm_out_sel
////////////////////////////////////////////////////////////////////////////////
localparam PLL_DSM_3RD_ORDER = 2'b11 ;
localparam PLL_DSM_2ND_ORDER = 2'b10 ;
localparam PLL_DSM_1ST_ORDER = 2'b01 ;
localparam PLL_DSM_DISABLE = 2'b00 ;
localparam local_pll_dsm_out_sel_0 = (pll_dsm_out_sel_0 == "disable") ? PLL_DSM_DISABLE :
								   (pll_dsm_out_sel_0 == "1st_order") ? PLL_DSM_1ST_ORDER :
								   (pll_dsm_out_sel_0 == "2nd_order") ? PLL_DSM_2ND_ORDER : PLL_DSM_3RD_ORDER;
localparam local_pll_dsm_out_sel_1 = (pll_dsm_out_sel_1 == "disable") ? PLL_DSM_DISABLE :
								   (pll_dsm_out_sel_1 == "1st_order") ? PLL_DSM_1ST_ORDER :
								   (pll_dsm_out_sel_1 == "2nd_order") ? PLL_DSM_2ND_ORDER : PLL_DSM_3RD_ORDER;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_carry_out
////////////////////////////////////////////////////////////////////////////////
localparam PLL_COUT_32B = 2'b11 ;
localparam PLL_COUT_24B = 2'b10 ;
localparam PLL_COUT_16B = 2'b01 ;
localparam PLL_COUT_8B = 2'b00 ;
localparam local_pll_fractional_carry_out_0 = (pll_fractional_carry_out_0 == 8) ? PLL_COUT_8B :
											(pll_fractional_carry_out_0 == 16) ? PLL_COUT_16B :
											(pll_fractional_carry_out_0 == 24) ? PLL_COUT_24B : PLL_COUT_32B;
localparam local_pll_fractional_carry_out_1 = (pll_fractional_carry_out_1 == 8) ? PLL_COUT_8B :
											(pll_fractional_carry_out_1 == 16) ? PLL_COUT_16B :
											(pll_fractional_carry_out_1 == 24) ? PLL_COUT_24B : PLL_COUT_32B;

											////////////////////////////////////////////////////////////////////////////////
// pll_dsm_dither
////////////////////////////////////////////////////////////////////////////////
localparam PLL_DITHER_3 = 2'b11 ;
localparam PLL_DITHER_2 = 2'b10 ;
localparam PLL_DITHER_1 = 2'b01 ;
localparam PLL_DITHER_DISABLE = 2'b00 ;
localparam local_pll_dsm_dither_0 = (pll_dsm_dither_0 == "disable") ? PLL_DITHER_DISABLE :
								  (pll_dsm_dither_0 == "pattern1") ? PLL_DITHER_1 :
								  (pll_dsm_dither_0 == "pattern2") ? PLL_DITHER_2 : PLL_DITHER_3;
localparam local_pll_dsm_dither_1 = (pll_dsm_dither_1 == "disable") ? PLL_DITHER_DISABLE :
								  (pll_dsm_dither_1 == "pattern1") ? PLL_DITHER_1 :
								  (pll_dsm_dither_1 == "pattern2") ? PLL_DITHER_2 : PLL_DITHER_3;

////////////////////////////////////////////////////////////////////////////////
// pll_ecn_bypass
////////////////////////////////////////////////////////////////////////////////
localparam PLL_ECN_BYPASS_ENABLE = 1'b1 ;
localparam PLL_ECN_BYPASS_DISABLE = 1'b0 ;
localparam local_pll_ecn_bypass_0 = (pll_ecn_bypass_0 == "false") ? PLL_ECN_BYPASS_DISABLE : PLL_ECN_BYPASS_ENABLE;
localparam local_pll_ecn_bypass_1 = (pll_ecn_bypass_1 == "false") ? PLL_ECN_BYPASS_DISABLE : PLL_ECN_BYPASS_ENABLE;
								  
wire [1:0] fbclk;
	arriav_ffpll_reconfig #(
		.P_XCLKIN_MUX_SO_0__PLL_CLKIN_0_SRC(local_pll_clkin_0_src_0),
		.P_XCLKIN_MUX_SO_0__PLL_CLKIN_1_SRC(local_pll_clkin_1_src_0),
        .P_XCLKIN_MUX_SO_0__PLL_CLK_SW_DLY(local_pll_clk_sw_dly_0), 
        .P_XCLKIN_MUX_SO_0__PLL_CLK_SW_DLY_SETTING(local_pll_clk_sw_dly_0), 	
        .P_XCLKIN_MUX_SO_0__PLL_MANU_CLK_SW_EN(local_pll_manu_clk_sw_en_0),
        .P_XCLKIN_MUX_SO_0__PLL_AUTO_CLK_SW_EN(local_pll_auto_clk_sw_en_0),
        .P_XCLKIN_MUX_SO_0__PLL_CLK_LOSS_SW_EN(local_pll_clk_loss_sw_en_0),
		.P_XCLKIN_MUX_SO_1__PLL_CLKIN_0_SRC(local_pll_clkin_0_src_1),
		.P_XCLKIN_MUX_SO_1__PLL_CLKIN_1_SRC(local_pll_clkin_1_src_1),
        .P_XCLKIN_MUX_SO_1__PLL_CLK_SW_DLY(local_pll_clk_sw_dly_1), 
        .P_XCLKIN_MUX_SO_1__PLL_CLK_SW_DLY_SETTING(local_pll_clk_sw_dly_1), 	
        .P_XCLKIN_MUX_SO_1__PLL_MANU_CLK_SW_EN(local_pll_manu_clk_sw_en_1),
        .P_XCLKIN_MUX_SO_1__PLL_AUTO_CLK_SW_EN(local_pll_auto_clk_sw_en_1),
        .P_XCLKIN_MUX_SO_1__PLL_CLK_LOSS_SW_EN(local_pll_clk_loss_sw_en_1),
    		
        .P_XFPLL_0__PLL_VCO_PH7_EN(local_pll_vco_ph7_en_0),
		.P_XFPLL_0__PLL_VCO_PH6_EN(local_pll_vco_ph6_en_0),
		.P_XFPLL_0__PLL_VCO_PH5_EN(local_pll_vco_ph5_en_0),
		.P_XFPLL_0__PLL_VCO_PH4_EN(local_pll_vco_ph4_en_0),
		.P_XFPLL_0__PLL_VCO_PH3_EN(local_pll_vco_ph3_en_0),
		.P_XFPLL_0__PLL_VCO_PH2_EN(local_pll_vco_ph2_en_0),
		.P_XFPLL_0__PLL_VCO_PH1_EN(local_pll_vco_ph1_en_0),
		.P_XFPLL_0__PLL_VCO_PH0_EN(local_pll_vco_ph0_en_0),
		.P_XFPLL_0__PLL_ENABLE(local_pll_enable_0),
		.P_XFPLL_0__PLL_CTRL_OVERRIDE_SETTING(local_pll_ctrl_override_setting_0),
		.P_XFPLL_0__PLL_FBCLK_MUX_2(local_pll_fbclk_mux_2_0),
		.P_XFPLL_0__PLL_FBCLK_MUX_1(local_pll_fbclk_mux_1_0),
		.P_XFPLL_0__PLL_N_CNT_BYPASS_EN(local_pll_n_cnt_bypass_en_0),
		.P_XFPLL_0__PLL_N_CNT_LO_DIV_SETTING(local_pll_n_cnt_lo_div_setting_0),
		.P_XFPLL_0__PLL_N_CNT_LO_DIV(local_pll_n_cnt_lo_div_0),
		.P_XFPLL_0__PLL_N_CNT_HI_DIV_SETTING(local_pll_n_cnt_hi_div_setting_0),
		.P_XFPLL_0__PLL_N_CNT_HI_DIV(local_pll_n_cnt_hi_div_0),
		.P_XFPLL_0__PLL_N_CNT_ODD_DIV_DUTY_EN(local_pll_n_cnt_odd_div_duty_en_0),
		.P_XFPLL_0__PLL_TCLK_SEL(local_pll_tclk_sel_0),
		.P_XFPLL_0__PLL_M_CNT_ODD_DIV_DUTY_EN(local_pll_m_cnt_odd_div_duty_en_0),
		.P_XFPLL_0__PLL_M_CNT_BYPASS_EN(local_pll_m_cnt_bypass_en_0),
		.P_XFPLL_0__PLL_M_CNT_IN_SRC(local_pll_m_cnt_in_src_0),
		.P_XFPLL_0__PLL_M_CNT_LO_DIV_SETTING(local_pll_m_cnt_lo_div_setting_0),
		.P_XFPLL_0__PLL_M_CNT_LO_DIV(local_pll_m_cnt_lo_div_0),
		.P_XFPLL_0__PLL_M_CNT_HI_DIV_SETTING(local_pll_m_cnt_hi_div_setting_0),
		.P_XFPLL_0__PLL_M_CNT_HI_DIV(local_pll_m_cnt_hi_div_0),
		.P_XFPLL_0__PLL_M_CNT_PRST(local_pll_m_cnt_prst_0),
		.P_XFPLL_0__PLL_M_CNT_PRST_SETTING(local_pll_m_cnt_prst_setting_0),
		.P_XFPLL_0__PLL_UNLOCK_FLTR_CFG_SETTING(local_pll_unlock_fltr_cfg_setting_0),
		.P_XFPLL_0__PLL_UNLOCK_FLTR_CFG(local_pll_unlock_fltr_cfg_0),
		.P_XFPLL_0__PLL_LOCK_FLTR_CFG_SETTING(local_pll_lock_fltr_cfg_setting_0),
		.P_XFPLL_0__PLL_LOCK_FLTR_CFG(local_pll_lock_fltr_cfg_0),
		.P_XFPLL_0__PLL_DSM_OUT_SEL(local_pll_dsm_out_sel_0),
		.P_XFPLL_0__PLL_FRACTIONAL_DIVISION_SETTING(local_pll_fractional_division_setting_0),
		.P_XFPLL_0__PLL_FRACTIONAL_DIVISION(local_pll_fractional_division_0),
		.P_XFPLL_0__PLL_FRACTIONAL_VALUE_READY(local_pll_fractional_value_ready_0),
		.P_XFPLL_0__PLL_FRACTIONAL_CARRY_OUT(local_pll_fractional_carry_out_0),
		.P_XFPLL_0__PLL_ECN_BYPASS(local_pll_ecn_bypass_0),
		.P_XFPLL_0__PLL_DSM_DITHER(local_pll_dsm_dither_0),
        .P_XFPLL_0__PLL_VCO_DIV(1'b1),
        .P_XFPLL_0__PLL_CP_CURRENT(local_pll_cp_current_0),
        .P_XFPLL_0__PLL_BWCTRL(local_pll_bwctrl_0),
		.P_XFPLL_1__PLL_VCO_PH7_EN(local_pll_vco_ph7_en_1),
		.P_XFPLL_1__PLL_VCO_PH6_EN(local_pll_vco_ph6_en_1),
		.P_XFPLL_1__PLL_VCO_PH5_EN(local_pll_vco_ph5_en_1),
		.P_XFPLL_1__PLL_VCO_PH4_EN(local_pll_vco_ph4_en_1),
		.P_XFPLL_1__PLL_VCO_PH3_EN(local_pll_vco_ph3_en_1),
		.P_XFPLL_1__PLL_VCO_PH2_EN(local_pll_vco_ph2_en_1),
		.P_XFPLL_1__PLL_VCO_PH1_EN(local_pll_vco_ph1_en_1),
		.P_XFPLL_1__PLL_VCO_PH0_EN(local_pll_vco_ph0_en_1),
		.P_XFPLL_1__PLL_ENABLE(local_pll_enable_1),
		.P_XFPLL_1__PLL_CTRL_OVERRIDE_SETTING(local_pll_ctrl_override_setting_1),
		.P_XFPLL_1__PLL_FBCLK_MUX_2(local_pll_fbclk_mux_2_1),
		.P_XFPLL_1__PLL_FBCLK_MUX_1(local_pll_fbclk_mux_1_1),
		.P_XFPLL_1__PLL_N_CNT_BYPASS_EN(local_pll_n_cnt_bypass_en_1),
		.P_XFPLL_1__PLL_N_CNT_LO_DIV_SETTING(local_pll_n_cnt_lo_div_setting_1),
		.P_XFPLL_1__PLL_N_CNT_LO_DIV(local_pll_n_cnt_lo_div_1),
		.P_XFPLL_1__PLL_N_CNT_HI_DIV_SETTING(local_pll_n_cnt_hi_div_setting_1),
		.P_XFPLL_1__PLL_N_CNT_HI_DIV(local_pll_n_cnt_hi_div_1),
		.P_XFPLL_1__PLL_N_CNT_ODD_DIV_DUTY_EN(local_pll_n_cnt_odd_div_duty_en_1),
		.P_XFPLL_1__PLL_TCLK_SEL(local_pll_tclk_sel_1),
		.P_XFPLL_1__PLL_M_CNT_ODD_DIV_DUTY_EN(local_pll_m_cnt_odd_div_duty_en_1),
		.P_XFPLL_1__PLL_M_CNT_BYPASS_EN(local_pll_m_cnt_bypass_en_1),
		.P_XFPLL_1__PLL_M_CNT_IN_SRC(local_pll_m_cnt_in_src_1),
		.P_XFPLL_1__PLL_M_CNT_LO_DIV_SETTING(local_pll_m_cnt_lo_div_setting_1),
		.P_XFPLL_1__PLL_M_CNT_LO_DIV(local_pll_m_cnt_lo_div_1),
		.P_XFPLL_1__PLL_M_CNT_HI_DIV_SETTING(local_pll_m_cnt_hi_div_setting_1),
		.P_XFPLL_1__PLL_M_CNT_HI_DIV(local_pll_m_cnt_hi_div_1),
		.P_XFPLL_1__PLL_M_CNT_PRST(local_pll_m_cnt_prst_1),
		.P_XFPLL_1__PLL_M_CNT_PRST_SETTING(local_pll_m_cnt_prst_setting_1),
		.P_XFPLL_1__PLL_UNLOCK_FLTR_CFG_SETTING(local_pll_unlock_fltr_cfg_setting_1),
		.P_XFPLL_1__PLL_UNLOCK_FLTR_CFG(local_pll_unlock_fltr_cfg_1),
		.P_XFPLL_1__PLL_LOCK_FLTR_CFG_SETTING(local_pll_lock_fltr_cfg_setting_1),
		.P_XFPLL_1__PLL_LOCK_FLTR_CFG(local_pll_lock_fltr_cfg_1),
		.P_XFPLL_1__PLL_DSM_OUT_SEL(local_pll_dsm_out_sel_1),
		.P_XFPLL_1__PLL_FRACTIONAL_DIVISION_SETTING(local_pll_fractional_division_setting_1),
		.P_XFPLL_1__PLL_FRACTIONAL_DIVISION(local_pll_fractional_division_1),
		.P_XFPLL_1__PLL_FRACTIONAL_VALUE_READY(local_pll_fractional_value_ready_1),
		.P_XFPLL_1__PLL_FRACTIONAL_CARRY_OUT(local_pll_fractional_carry_out_1),
		.P_XFPLL_1__PLL_DSM_DITHER(local_pll_dsm_dither_1),
		.P_XFPLL_1__PLL_ECN_BYPASS(local_pll_ecn_bypass_1),
        .P_XFPLL_1__PLL_VCO_DIV(1'b1),
        .P_XFPLL_1__PLL_CP_CURRENT(local_pll_cp_current_1),
        .P_XFPLL_1__PLL_BWCTRL(local_pll_bwctrl_1),

        .P_X18CCNTS__XCCNT_0__C_CNT_IN_SRC(local_c_cnt_in_src_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PRST(local_c_cnt_prst_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PRST_USER(local_c_cnt_prst_user_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_0),
		.P_X18CCNTS__XCCNT_1__C_CNT_IN_SRC(local_c_cnt_in_src_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PRST(local_c_cnt_prst_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PRST_USER(local_c_cnt_prst_user_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_1),
		.P_X18CCNTS__XCCNT_2__C_CNT_IN_SRC(local_c_cnt_in_src_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PRST(local_c_cnt_prst_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PRST_USER(local_c_cnt_prst_user_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_2),
		.P_X18CCNTS__XCCNT_3__C_CNT_IN_SRC(local_c_cnt_in_src_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PRST(local_c_cnt_prst_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PRST_USER(local_c_cnt_prst_user_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_3),
		.P_X18CCNTS__XCCNT_4__C_CNT_IN_SRC(local_c_cnt_in_src_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PRST(local_c_cnt_prst_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PRST_USER(local_c_cnt_prst_user_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_4),
		.P_X18CCNTS__XCCNT_5__C_CNT_IN_SRC(local_c_cnt_in_src_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PRST(local_c_cnt_prst_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PRST_USER(local_c_cnt_prst_user_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_5),
		.P_X18CCNTS__XCCNT_6__C_CNT_IN_SRC(local_c_cnt_in_src_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PRST(local_c_cnt_prst_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PRST_USER(local_c_cnt_prst_user_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_6),
		.P_X18CCNTS__XCCNT_7__C_CNT_IN_SRC(local_c_cnt_in_src_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PRST(local_c_cnt_prst_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PRST_USER(local_c_cnt_prst_user_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_7),
		.P_X18CCNTS__XCCNT_8__C_CNT_IN_SRC(local_c_cnt_in_src_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PRST(local_c_cnt_prst_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PRST_USER(local_c_cnt_prst_user_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_8),
		.P_X18CCNTS__XCCNT_9__C_CNT_IN_SRC(local_c_cnt_in_src_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PRST(local_c_cnt_prst_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PRST_USER(local_c_cnt_prst_user_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_9),
		.P_X18CCNTS__XCCNT_10__C_CNT_IN_SRC(local_c_cnt_in_src_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PRST(local_c_cnt_prst_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PRST_USER(local_c_cnt_prst_user_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_10),
		.P_X18CCNTS__XCCNT_11__C_CNT_IN_SRC(local_c_cnt_in_src_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PRST(local_c_cnt_prst_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PRST_USER(local_c_cnt_prst_user_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_11),
		.P_X18CCNTS__XCCNT_12__C_CNT_IN_SRC(local_c_cnt_in_src_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PRST(local_c_cnt_prst_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PRST_USER(local_c_cnt_prst_user_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_12),
		.P_X18CCNTS__XCCNT_13__C_CNT_IN_SRC(local_c_cnt_in_src_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PRST(local_c_cnt_prst_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PRST_USER(local_c_cnt_prst_user_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_13),
		.P_X18CCNTS__XCCNT_14__C_CNT_IN_SRC(local_c_cnt_in_src_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PRST(local_c_cnt_prst_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PRST_USER(local_c_cnt_prst_user_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_14),
		.P_X18CCNTS__XCCNT_15__C_CNT_IN_SRC(local_c_cnt_in_src_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PRST(local_c_cnt_prst_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PRST_USER(local_c_cnt_prst_user_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_15),
		.P_X18CCNTS__XCCNT_16__C_CNT_IN_SRC(local_c_cnt_in_src_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PRST(local_c_cnt_prst_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PRST_USER(local_c_cnt_prst_user_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_16),
		.P_X18CCNTS__XCCNT_17__C_CNT_IN_SRC(local_c_cnt_in_src_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PRST(local_c_cnt_prst_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PRST_USER(local_c_cnt_prst_user_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_17)		
	) arriav_ffpll_inst (
	  // arriav_pll_dpa_output pins
	  .dpaclk0_i(phout_0),
	  .dpaclk1_i(phout_1),
	  
	  // arriav_pll_refclk_select pins
	  .pll_cas_in0(adjpllin[0]),
	  .coreclk0(coreclkin[0]),	  	  .coreclk1(cclk[0]),
	  .extswitch0(extswitch[0]),
	  .iqtxrxclk_fpll0(iqtxrxclkin[0]),
	  .ref_iqclk_fpll0(plliqclkin[0]),
	  .rx_iqclk_fpll0(rxiqclkin[0]),
	  .clkin(clkin),
	  .refclk_fpll0(refiqclk_0[0]),
	  .clk0_bad0(clk0bad[0]),
	  .clk1_bad0(clk1bad[0]),
	  .clksel0(pllclksel[0]),

	  // arriav_pll_reconfig pins
	  .atpgmode0(atpgmode[0]),
	  .dprio0_clk(clk[0]),
	  .ffpll_csr_test0(fpllcsrtest[0]),
	  .iocsr_clkin(iocsrclkin[0]),
	  .iocsr_datain(iocsrdatain[0]),
	  .dprio0_mdio_dis(mdiodis[0]),
	  .phase_en0(phaseen[0]),
	  .dprio0_read(read[0]),
	  .dprio0_rst_n(rstn[0]),
	  .scanen0(scanen[0]),
	  .dprio0_ser_shift_load(sershiftload[0]),
	  .up_dn0(updn[0]),
	  .dprio0_write(write[0]),
	  .dprio0_reg_addr(addr_0),
	  .dprio1_reg_addr(addr_1),
	  .dprio0_byte_en(byteen_0),
	  .dprio1_byte_en(byteen_1),
	  .cnt_sel0(cntsel_0),
	  .cnt_sel1(cntsel_1),
	  .dprio0_writedata(din_0),
	  .dprio1_writedata(din_1),
	  .dprio0_block_select(blockselect[0]),
	  .iocsr_dataout(iocsrdataout[0]),
	  .phase_done0(phasedone[0]),
	  .dprio0_readdata(dout_0),
	  .dprio1_readdata(dout_1),
	  
	  // arriav_fractional_pll pins
          .pllmout0(fbclk[0]),
          .fbclk_in0(fbclk[0]),
	  .fbclk_fpll0(fbclkfpll[0]),
	  .fblvds_in0(lvdfbin[0]),
	  .nreset0(nresync[0]),
	  .pfden0(pfden[0]),
	  .zdb_in0(zdb[0]),
	  .fblvds_out0(fblvdsout[0]),
	  .lock0(lock[0]),
	  
	  // arriav_pll_extclk_output pins
	  .clken(clken),
	  .extclk(extclk),
	  
	  // arriav_pll_dll_output pins
	  .plldout0(clkout[0]),
	  
	  // arriav_pll_lvds_output pins
	  .loaden0({loaden[1], loaden[0]}),
	  .loaden1({loaden[3], loaden[2]}),
	  .lvds_clk0({lvdsclk[1], lvdsclk[0]}),
	  .lvds_clk1({lvdsclk[1], lvdsclk[0]}),
	  
	  // arriav_pll_output_counter pins
	  .divclk(divclk),
	  .pll_cas_out1(),
	  // others
	  .ioplniotri(nresync[0]),
	  .nfrzdrv(nresync[0]),
	  .pllbias(1'b1)
	);	// assign cascade_out to divclk	// This is used as a workaround in RTL simulation as cascade_out needs to be output counter location dependent
	assign cascade_out = divclk;
endmodule
`timescale 1 ps/1 ps

module altera_arriavgz_pll
#(	
	// Parameter declarations and default value assignments
	parameter number_of_counters = 18,	
	parameter number_of_fplls = 1,
	parameter number_of_extclks = 4,
	parameter number_of_dlls = 2,
	parameter number_of_lvds = 4,	

	// arriavgz_pll_refclk_select parameters -- FF_PLL 0
	parameter pll_auto_clk_sw_en_0 = "false",
	parameter pll_clk_loss_edge_0 = "both_edges",
	parameter pll_clk_loss_sw_en_0 = "false",
	parameter pll_clk_sw_dly_0 = 0,
	parameter pll_clkin_0_src_0 = "clk_0",
	parameter pll_clkin_1_src_0 = "clk_0",
	parameter pll_manu_clk_sw_en_0 = "false",
	parameter pll_sw_refclk_src_0 = "clk_0",
	
	// arriavgz_pll_refclk_select parameters -- FF_PLL 1
	parameter pll_auto_clk_sw_en_1 = "false",
	parameter pll_clk_loss_edge_1 = "both_edges",
	parameter pll_clk_loss_sw_en_1 = "false",
	parameter pll_clk_sw_dly_1 = 0,
	parameter pll_clkin_0_src_1 = "clk_1",
	parameter pll_clkin_1_src_1 = "clk_1",
	parameter pll_manu_clk_sw_en_1 = "false",
	parameter pll_sw_refclk_src_1 = "clk_1",
	
	// arriavgz_fractional_pll parameters -- FF_PLL 0
	parameter pll_output_clock_frequency_0 = "700.0 MHz",
	parameter reference_clock_frequency_0 = "700.0 MHz",
	parameter mimic_fbclk_type_0 = "gclk",
	parameter dsm_accumulator_reset_value_0 = 0,
	parameter forcelock_0 = "false",
	parameter nreset_invert_0 = "false",
	parameter pll_atb_0 = 0,
	parameter pll_bwctrl_0 = 1000,
	parameter pll_cmp_buf_dly_0 = "0 ps",
	parameter pll_cp_comp_0 = "true",
	parameter pll_cp_current_0 = 20,
	parameter pll_ctrl_override_setting_0 = "true",
	parameter pll_dsm_dither_0 = "disable",
	parameter pll_dsm_out_sel_0 = "disable",
	parameter pll_dsm_reset_0 = "false",
	parameter pll_ecn_bypass_0 = "false",
	parameter pll_ecn_test_en_0 = "false",
	parameter pll_enable_0 = "true",
	parameter pll_fbclk_mux_1_0 = "fb",
	parameter pll_fbclk_mux_2_0 = "m_cnt",
	parameter pll_fractional_carry_out_0 = 24,
	parameter pll_fractional_division_0 = 1,
	parameter pll_fractional_value_ready_0 = "true",
	parameter pll_lf_testen_0 = "false",
	parameter pll_lock_fltr_cfg_0 = 25,
	parameter pll_lock_fltr_test_0 = "false",
	parameter pll_m_cnt_bypass_en_0 = "false",
	parameter pll_m_cnt_coarse_dly_0 = "0 ps",
	parameter pll_m_cnt_fine_dly_0 = "0 ps",
	parameter pll_m_cnt_hi_div_0 = 3,
	parameter pll_m_cnt_in_src_0 = "ph_mux_clk",
	parameter pll_m_cnt_lo_div_0 = 3,
	parameter pll_m_cnt_odd_div_duty_en_0 = "false",
	parameter pll_m_cnt_ph_mux_prst_0 = 0,
	parameter pll_m_cnt_prst_0 = 256,
	parameter pll_n_cnt_bypass_en_0 = "true",
	parameter pll_n_cnt_coarse_dly_0 = "0 ps",
	parameter pll_n_cnt_fine_dly_0 = "0 ps",
	parameter pll_n_cnt_hi_div_0 = 1,
	parameter pll_n_cnt_lo_div_0 = 1,
	parameter pll_n_cnt_odd_div_duty_en_0 = "false",
	parameter pll_ref_buf_dly_0 = "0 ps",
	parameter pll_reg_boost_0 = 0,
	parameter pll_regulator_bypass_0 = "false",
	parameter pll_ripplecap_ctrl_0 = 0,
	parameter pll_slf_rst_0 = "false",
	parameter pll_tclk_mux_en_0 = "false",
	parameter pll_tclk_sel_0 = "n_src",
	parameter pll_test_enable_0 = "false",
	parameter pll_testdn_enable_0 = "false",
	parameter pll_testup_enable_0 = "false",
	parameter pll_unlock_fltr_cfg_0 = 1,
	parameter pll_vco_div_0 = 0,
	parameter pll_vco_ph0_en_0 = "true",
	parameter pll_vco_ph1_en_0 = "true",
	parameter pll_vco_ph2_en_0 = "true",
	parameter pll_vco_ph3_en_0 = "true",
	parameter pll_vco_ph4_en_0 = "true",
	parameter pll_vco_ph5_en_0 = "true",
	parameter pll_vco_ph6_en_0 = "true",
	parameter pll_vco_ph7_en_0 = "true",
	parameter pll_vctrl_test_voltage_0 = 750,
	parameter vccd0g_atb_0 = "disable",
	parameter vccd0g_output_0 = 0,
	parameter vccd1g_atb_0 = "disable",
	parameter vccd1g_output_0 = 0,
	parameter vccm1g_tap_0 = 2,
	parameter vccr_pd_0 = "false",
	parameter vcodiv_override_0 = "false",
    parameter sim_use_fast_model_0 = "false",

	// arriavgz_fractional_pll parameters -- FF_PLL 1
	parameter pll_output_clock_frequency_1 = "300.0 MHz",
	parameter reference_clock_frequency_1 = "100.0 MHz",
	parameter mimic_fbclk_type_1 = "gclk",
	parameter dsm_accumulator_reset_value_1 = 0,
	parameter forcelock_1 = "false",
	parameter nreset_invert_1 = "false",
	parameter pll_atb_1 = 0,
	parameter pll_bwctrl_1 = 1000,
	parameter pll_cmp_buf_dly_1 = "0 ps",
	parameter pll_cp_comp_1 = "true",
	parameter pll_cp_current_1 = 30,
	parameter pll_ctrl_override_setting_1 = "false",
	parameter pll_dsm_dither_1 = "disable",
	parameter pll_dsm_out_sel_1 = "disable",
	parameter pll_dsm_reset_1 = "false",
	parameter pll_ecn_bypass_1 = "false",
	parameter pll_ecn_test_en_1 = "false",
	parameter pll_enable_1 = "false",
	parameter pll_fbclk_mux_1_1 = "glb",
	parameter pll_fbclk_mux_2_1 = "fb_1",
	parameter pll_fractional_carry_out_1 = 24,
	parameter pll_fractional_division_1 = 1,
	parameter pll_fractional_value_ready_1 = "true",
	parameter pll_lf_testen_1 = "false",
	parameter pll_lock_fltr_cfg_1 = 25,
	parameter pll_lock_fltr_test_1 = "false",
	parameter pll_m_cnt_bypass_en_1 = "false",
	parameter pll_m_cnt_coarse_dly_1 = "0 ps",
	parameter pll_m_cnt_fine_dly_1 = "0 ps",
	parameter pll_m_cnt_hi_div_1 = 2,
	parameter pll_m_cnt_in_src_1 = "ph_mux_clk",
	parameter pll_m_cnt_lo_div_1 = 1,
	parameter pll_m_cnt_odd_div_duty_en_1 = "true",
	parameter pll_m_cnt_ph_mux_prst_1 = 0,
	parameter pll_m_cnt_prst_1 = 256,
	parameter pll_n_cnt_bypass_en_1 = "true",
	parameter pll_n_cnt_coarse_dly_1 = "0 ps",
	parameter pll_n_cnt_fine_dly_1 = "0 ps",
	parameter pll_n_cnt_hi_div_1 = 256,
	parameter pll_n_cnt_lo_div_1 = 256,
	parameter pll_n_cnt_odd_div_duty_en_1 = "false",
	parameter pll_ref_buf_dly_1 = "0 ps",
	parameter pll_reg_boost_1 = 0,
	parameter pll_regulator_bypass_1 = "false",
	parameter pll_ripplecap_ctrl_1 = 0,
	parameter pll_slf_rst_1 = "false",
	parameter pll_tclk_mux_en_1 = "false",
	parameter pll_tclk_sel_1 = "n_src",
	parameter pll_test_enable_1 = "false",
	parameter pll_testdn_enable_1 = "false",
	parameter pll_testup_enable_1 = "false",
	parameter pll_unlock_fltr_cfg_1 = 2,
	parameter pll_vco_div_1 = 1,
	parameter pll_vco_ph0_en_1 = "true",
	parameter pll_vco_ph1_en_1 = "true",
	parameter pll_vco_ph2_en_1 = "true",
	parameter pll_vco_ph3_en_1 = "true",
	parameter pll_vco_ph4_en_1 = "true",
	parameter pll_vco_ph5_en_1 = "true",
	parameter pll_vco_ph6_en_1 = "true",
	parameter pll_vco_ph7_en_1 = "true",
	parameter pll_vctrl_test_voltage_1 = 750,
	parameter vccd0g_atb_1 = "disable",
	parameter vccd0g_output_1 = 0,
	parameter vccd1g_atb_1 = "disable",
	parameter vccd1g_output_1 = 0,
	parameter vccm1g_tap_1 = 2,
	parameter vccr_pd_1 = "false",
	parameter vcodiv_override_1 = "false",
    parameter sim_use_fast_model_1 = "false",
    
	// arriavgz_pll_output_counter parameters -- counter 0
	parameter output_clock_frequency_0 = "100.0 MHz",
	parameter enable_output_counter_0 = "true",
	parameter phase_shift_0 = "0 ps",
	parameter duty_cycle_0 = 50,
	parameter c_cnt_coarse_dly_0 = "0 ps",
	parameter c_cnt_fine_dly_0 = "0 ps",
	parameter c_cnt_in_src_0 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_0 = 0,
	parameter c_cnt_prst_0 = 1,
	parameter cnt_fpll_src_0 = "fpll_0",
	parameter dprio0_cnt_bypass_en_0 = "true",
	parameter dprio0_cnt_hi_div_0 = 3,
	parameter dprio0_cnt_lo_div_0 = 3,
	parameter dprio0_cnt_odd_div_even_duty_en_0 = "false",
	parameter dprio1_cnt_bypass_en_0 = dprio0_cnt_bypass_en_0,
	parameter dprio1_cnt_hi_div_0 = dprio0_cnt_hi_div_0,
	parameter dprio1_cnt_lo_div_0 = dprio0_cnt_lo_div_0,
	parameter dprio1_cnt_odd_div_even_duty_en_0 = dprio0_cnt_odd_div_even_duty_en_0,
	
	parameter output_clock_frequency_1 = "0 ps",
	parameter enable_output_counter_1 = "true",
	parameter phase_shift_1 = "0 ps",
	parameter duty_cycle_1 = 50,
	parameter c_cnt_coarse_dly_1 = "0 ps",
	parameter c_cnt_fine_dly_1 = "0 ps",
	parameter c_cnt_in_src_1 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_1 = 0,
	parameter c_cnt_prst_1 = 1,
	parameter cnt_fpll_src_1 = "fpll_0",
	parameter dprio0_cnt_bypass_en_1 = "true",
	parameter dprio0_cnt_hi_div_1 = 2,
	parameter dprio0_cnt_lo_div_1 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_1 = "true",
	parameter dprio1_cnt_bypass_en_1 = dprio0_cnt_bypass_en_1,
	parameter dprio1_cnt_hi_div_1 = dprio0_cnt_hi_div_1,
	parameter dprio1_cnt_lo_div_1 = dprio0_cnt_lo_div_1,
	parameter dprio1_cnt_odd_div_even_duty_en_1 = dprio0_cnt_odd_div_even_duty_en_1,
	
	parameter output_clock_frequency_2 = "0 ps",
	parameter enable_output_counter_2 = "true",
	parameter phase_shift_2 = "0 ps",
	parameter duty_cycle_2 = 50,
	parameter c_cnt_coarse_dly_2 = "0 ps",
	parameter c_cnt_fine_dly_2 = "0 ps",
	parameter c_cnt_in_src_2 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_2 = 0,
	parameter c_cnt_prst_2 = 1,
	parameter cnt_fpll_src_2 = "fpll_0",
	parameter dprio0_cnt_bypass_en_2 = "true",
	parameter dprio0_cnt_hi_div_2 = 1,
	parameter dprio0_cnt_lo_div_2 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_2 = "false",
	parameter dprio1_cnt_bypass_en_2 = dprio0_cnt_bypass_en_2,
	parameter dprio1_cnt_hi_div_2 = dprio0_cnt_hi_div_2,
	parameter dprio1_cnt_lo_div_2 = dprio0_cnt_lo_div_2,
	parameter dprio1_cnt_odd_div_even_duty_en_2 = dprio0_cnt_odd_div_even_duty_en_2,
	
	parameter output_clock_frequency_3 = "0 ps",
	parameter enable_output_counter_3 = "true",
	parameter phase_shift_3 = "0 ps",
	parameter duty_cycle_3 = 50,
	parameter c_cnt_coarse_dly_3 = "0 ps",
	parameter c_cnt_fine_dly_3 = "0 ps",
	parameter c_cnt_in_src_3 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_3 = 0,
	parameter c_cnt_prst_3 = 1,
	parameter cnt_fpll_src_3 = "fpll_0",
	parameter dprio0_cnt_bypass_en_3 = "false",
	parameter dprio0_cnt_hi_div_3 = 1,
	parameter dprio0_cnt_lo_div_3 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_3 = "false",
	parameter dprio1_cnt_bypass_en_3 = dprio0_cnt_bypass_en_3,
	parameter dprio1_cnt_hi_div_3 = dprio0_cnt_hi_div_3,
	parameter dprio1_cnt_lo_div_3 = dprio0_cnt_lo_div_3,
	parameter dprio1_cnt_odd_div_even_duty_en_3 = dprio0_cnt_odd_div_even_duty_en_3,
	
	parameter output_clock_frequency_4 = "0 ps",
	parameter enable_output_counter_4 = "true",
	parameter phase_shift_4 = "0 ps",
	parameter duty_cycle_4 = 50,
	parameter c_cnt_coarse_dly_4 = "0 ps",
	parameter c_cnt_fine_dly_4 = "0 ps",
	parameter c_cnt_in_src_4 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_4 = 0,
	parameter c_cnt_prst_4 = 1,
	parameter cnt_fpll_src_4 = "fpll_0",
	parameter dprio0_cnt_bypass_en_4 = "false",
	parameter dprio0_cnt_hi_div_4 = 1,
	parameter dprio0_cnt_lo_div_4 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_4 = "false",
	parameter dprio1_cnt_bypass_en_4 = dprio0_cnt_bypass_en_4,
	parameter dprio1_cnt_hi_div_4 = dprio0_cnt_hi_div_4,
	parameter dprio1_cnt_lo_div_4 = dprio0_cnt_lo_div_4,
	parameter dprio1_cnt_odd_div_even_duty_en_4 = dprio0_cnt_odd_div_even_duty_en_4,
	
	parameter output_clock_frequency_5 = "0 ps",
	parameter enable_output_counter_5 = "true",
	parameter phase_shift_5 = "0 ps",
	parameter duty_cycle_5 = 50,
	parameter c_cnt_coarse_dly_5 = "0 ps",
	parameter c_cnt_fine_dly_5 = "0 ps",
	parameter c_cnt_in_src_5 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_5 = 0,
	parameter c_cnt_prst_5 = 1,
	parameter cnt_fpll_src_5 = "fpll_0",
	parameter dprio0_cnt_bypass_en_5 = "false",
	parameter dprio0_cnt_hi_div_5 = 1,
	parameter dprio0_cnt_lo_div_5 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_5 = "false",
	parameter dprio1_cnt_bypass_en_5 = dprio0_cnt_bypass_en_5,
	parameter dprio1_cnt_hi_div_5 = dprio0_cnt_hi_div_5,
	parameter dprio1_cnt_lo_div_5 = dprio0_cnt_lo_div_5,
	parameter dprio1_cnt_odd_div_even_duty_en_5 = dprio0_cnt_odd_div_even_duty_en_5,
	
	parameter output_clock_frequency_6 = "0 ps",
	parameter enable_output_counter_6 = "true",
	parameter phase_shift_6 = "0 ps",
	parameter duty_cycle_6 = 50,
	parameter c_cnt_coarse_dly_6 = "0 ps",
	parameter c_cnt_fine_dly_6 = "0 ps",
	parameter c_cnt_in_src_6 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_6 = 0,
	parameter c_cnt_prst_6 = 1,
	parameter cnt_fpll_src_6 = "fpll_0",
	parameter dprio0_cnt_bypass_en_6 = "false",
	parameter dprio0_cnt_hi_div_6 = 1,
	parameter dprio0_cnt_lo_div_6 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_6 = "false",
	parameter dprio1_cnt_bypass_en_6 = dprio0_cnt_bypass_en_6,
	parameter dprio1_cnt_hi_div_6 = dprio0_cnt_hi_div_6,
	parameter dprio1_cnt_lo_div_6 = dprio0_cnt_lo_div_6,
	parameter dprio1_cnt_odd_div_even_duty_en_6 = dprio0_cnt_odd_div_even_duty_en_6,
	
	parameter output_clock_frequency_7 = "0 ps",
	parameter enable_output_counter_7 = "true",
	parameter phase_shift_7 = "0 ps",
	parameter duty_cycle_7 = 50,
	parameter c_cnt_coarse_dly_7 = "0 ps",
	parameter c_cnt_fine_dly_7 = "0 ps",
	parameter c_cnt_in_src_7 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_7 = 0,
	parameter c_cnt_prst_7 = 1,
	parameter cnt_fpll_src_7 = "fpll_0",
	parameter dprio0_cnt_bypass_en_7 = "false",
	parameter dprio0_cnt_hi_div_7 = 1,
	parameter dprio0_cnt_lo_div_7 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_7 = "false",
	parameter dprio1_cnt_bypass_en_7 = dprio0_cnt_bypass_en_7,
	parameter dprio1_cnt_hi_div_7 = dprio0_cnt_hi_div_7,
	parameter dprio1_cnt_lo_div_7 = dprio0_cnt_lo_div_7,
	parameter dprio1_cnt_odd_div_even_duty_en_7 = dprio0_cnt_odd_div_even_duty_en_7,
	
	parameter output_clock_frequency_8 = "0 ps",
	parameter enable_output_counter_8 = "true",
	parameter phase_shift_8 = "0 ps",
	parameter duty_cycle_8 = 50,
	parameter c_cnt_coarse_dly_8 = "0 ps",
	parameter c_cnt_fine_dly_8 = "0 ps",
	parameter c_cnt_in_src_8 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_8 = 0,
	parameter c_cnt_prst_8 = 1,
	parameter cnt_fpll_src_8 = "fpll_0",
	parameter dprio0_cnt_bypass_en_8 = "false",
	parameter dprio0_cnt_hi_div_8 = 1,
	parameter dprio0_cnt_lo_div_8 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_8 = "false",
	parameter dprio1_cnt_bypass_en_8 = dprio0_cnt_bypass_en_8,
	parameter dprio1_cnt_hi_div_8 = dprio0_cnt_hi_div_8,
	parameter dprio1_cnt_lo_div_8 = dprio0_cnt_lo_div_8,
	parameter dprio1_cnt_odd_div_even_duty_en_8 = dprio0_cnt_odd_div_even_duty_en_8,
	
	parameter output_clock_frequency_9 = "0 ps",
	parameter enable_output_counter_9 = "true",
	parameter phase_shift_9 = "0 ps",
	parameter duty_cycle_9 = 50,
	parameter c_cnt_coarse_dly_9 = "0 ps",
	parameter c_cnt_fine_dly_9 = "0 ps",
	parameter c_cnt_in_src_9 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_9 = 0,
	parameter c_cnt_prst_9 = 1,
	parameter cnt_fpll_src_9 = "fpll_0",
	parameter dprio0_cnt_bypass_en_9 = "false",
	parameter dprio0_cnt_hi_div_9 = 1,
	parameter dprio0_cnt_lo_div_9 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_9 = "false",
	parameter dprio1_cnt_bypass_en_9 = dprio0_cnt_bypass_en_9,
	parameter dprio1_cnt_hi_div_9 = dprio0_cnt_hi_div_9,
	parameter dprio1_cnt_lo_div_9 = dprio0_cnt_lo_div_9,
	parameter dprio1_cnt_odd_div_even_duty_en_9 = dprio0_cnt_odd_div_even_duty_en_9,
	
	parameter output_clock_frequency_10 = "0 ps",
	parameter enable_output_counter_10 = "true",
	parameter phase_shift_10 = "0 ps",
	parameter duty_cycle_10 = 50,
	parameter c_cnt_coarse_dly_10 = "0 ps",
	parameter c_cnt_fine_dly_10 = "0 ps",
	parameter c_cnt_in_src_10 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_10 = 0,
	parameter c_cnt_prst_10 = 1,
	parameter cnt_fpll_src_10 = "fpll_0",
	parameter dprio0_cnt_bypass_en_10 = "false",
	parameter dprio0_cnt_hi_div_10 = 1,
	parameter dprio0_cnt_lo_div_10 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_10 = "false",
	parameter dprio1_cnt_bypass_en_10 = dprio0_cnt_bypass_en_10,
	parameter dprio1_cnt_hi_div_10 = dprio0_cnt_hi_div_10,
	parameter dprio1_cnt_lo_div_10 = dprio0_cnt_lo_div_10,
	parameter dprio1_cnt_odd_div_even_duty_en_10 = dprio0_cnt_odd_div_even_duty_en_10,
	
	parameter output_clock_frequency_11 = "0 ps",
	parameter enable_output_counter_11 = "true",
	parameter phase_shift_11 = "0 ps",
	parameter duty_cycle_11 = 50,
	parameter c_cnt_coarse_dly_11 = "0 ps",
	parameter c_cnt_fine_dly_11 = "0 ps",
	parameter c_cnt_in_src_11 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_11 = 0,
	parameter c_cnt_prst_11 = 1,
	parameter cnt_fpll_src_11 = "fpll_0",
	parameter dprio0_cnt_bypass_en_11 = "false",
	parameter dprio0_cnt_hi_div_11 = 1,
	parameter dprio0_cnt_lo_div_11 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_11 = "false",
	parameter dprio1_cnt_bypass_en_11 = dprio0_cnt_bypass_en_11,
	parameter dprio1_cnt_hi_div_11 = dprio0_cnt_hi_div_11,
	parameter dprio1_cnt_lo_div_11 = dprio0_cnt_lo_div_11,
	parameter dprio1_cnt_odd_div_even_duty_en_11 = dprio0_cnt_odd_div_even_duty_en_11,
	
	parameter output_clock_frequency_12 = "0 ps",
	parameter enable_output_counter_12 = "true",
	parameter phase_shift_12 = "0 ps",
	parameter duty_cycle_12 = 50,
	parameter c_cnt_coarse_dly_12 = "0 ps",
	parameter c_cnt_fine_dly_12 = "0 ps",
	parameter c_cnt_in_src_12 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_12 = 0,
	parameter c_cnt_prst_12 = 1,
	parameter cnt_fpll_src_12 = "fpll_0",
	parameter dprio0_cnt_bypass_en_12 = "false",
	parameter dprio0_cnt_hi_div_12 = 1,
	parameter dprio0_cnt_lo_div_12 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_12 = "false",
	parameter dprio1_cnt_bypass_en_12 = dprio0_cnt_bypass_en_12,
	parameter dprio1_cnt_hi_div_12 = dprio0_cnt_hi_div_12,
	parameter dprio1_cnt_lo_div_12 = dprio0_cnt_lo_div_12,
	parameter dprio1_cnt_odd_div_even_duty_en_12 = dprio0_cnt_odd_div_even_duty_en_12,
	
	parameter output_clock_frequency_13 = "0 ps",
	parameter enable_output_counter_13 = "true",
	parameter phase_shift_13 = "0 ps",
	parameter duty_cycle_13 = 50,
	parameter c_cnt_coarse_dly_13 = "0 ps",
	parameter c_cnt_fine_dly_13 = "0 ps",
	parameter c_cnt_in_src_13 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_13 = 0,
	parameter c_cnt_prst_13 = 1,
	parameter cnt_fpll_src_13 = "fpll_0",
	parameter dprio0_cnt_bypass_en_13 = "false",
	parameter dprio0_cnt_hi_div_13 = 1,
	parameter dprio0_cnt_lo_div_13 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_13 = "false",
	parameter dprio1_cnt_bypass_en_13 = dprio0_cnt_bypass_en_13,
	parameter dprio1_cnt_hi_div_13 = dprio0_cnt_hi_div_13,
	parameter dprio1_cnt_lo_div_13 = dprio0_cnt_lo_div_13,
	parameter dprio1_cnt_odd_div_even_duty_en_13 = dprio0_cnt_odd_div_even_duty_en_13,
	
	parameter output_clock_frequency_14 = "0 ps",
	parameter enable_output_counter_14 = "true",
	parameter phase_shift_14 = "0 ps",
	parameter duty_cycle_14 = 50,
	parameter c_cnt_coarse_dly_14 = "0 ps",
	parameter c_cnt_fine_dly_14 = "0 ps",
	parameter c_cnt_in_src_14 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_14 = 0,
	parameter c_cnt_prst_14 = 1,
	parameter cnt_fpll_src_14 = "fpll_0",
	parameter dprio0_cnt_bypass_en_14 = "false",
	parameter dprio0_cnt_hi_div_14 = 1,
	parameter dprio0_cnt_lo_div_14 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_14 = "false",
	parameter dprio1_cnt_bypass_en_14 = dprio0_cnt_bypass_en_14,
	parameter dprio1_cnt_hi_div_14 = dprio0_cnt_hi_div_14,
	parameter dprio1_cnt_lo_div_14 = dprio0_cnt_lo_div_14,
	parameter dprio1_cnt_odd_div_even_duty_en_14 = dprio0_cnt_odd_div_even_duty_en_14,
	
	parameter output_clock_frequency_15 = "0 ps",
	parameter enable_output_counter_15 = "true",
	parameter phase_shift_15 = "0 ps",
	parameter duty_cycle_15 = 50,
	parameter c_cnt_coarse_dly_15 = "0 ps",
	parameter c_cnt_fine_dly_15 = "0 ps",
	parameter c_cnt_in_src_15 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_15 = 0,
	parameter c_cnt_prst_15 = 1,
	parameter cnt_fpll_src_15 = "fpll_0",
	parameter dprio0_cnt_bypass_en_15 = "false",
	parameter dprio0_cnt_hi_div_15 = 1,
	parameter dprio0_cnt_lo_div_15 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_15 = "false",
	parameter dprio1_cnt_bypass_en_15 = dprio0_cnt_bypass_en_15,
	parameter dprio1_cnt_hi_div_15 = dprio0_cnt_hi_div_15,
	parameter dprio1_cnt_lo_div_15 = dprio0_cnt_lo_div_15,
	parameter dprio1_cnt_odd_div_even_duty_en_15 = dprio0_cnt_odd_div_even_duty_en_15,
	
	parameter output_clock_frequency_16 = "0 ps",
	parameter enable_output_counter_16 = "true",
	parameter phase_shift_16 = "0 ps",
	parameter duty_cycle_16 = 50,
	parameter c_cnt_coarse_dly_16 = "0 ps",
	parameter c_cnt_fine_dly_16 = "0 ps",
	parameter c_cnt_in_src_16 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_16 = 0,
	parameter c_cnt_prst_16 = 1,
	parameter cnt_fpll_src_16 = "fpll_0",
	parameter dprio0_cnt_bypass_en_16 = "false",
	parameter dprio0_cnt_hi_div_16 = 1,
	parameter dprio0_cnt_lo_div_16 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_16 = "false",
	parameter dprio1_cnt_bypass_en_16 = dprio0_cnt_bypass_en_16,
	parameter dprio1_cnt_hi_div_16 = dprio0_cnt_hi_div_16,
	parameter dprio1_cnt_lo_div_16 = dprio0_cnt_lo_div_16,
	parameter dprio1_cnt_odd_div_even_duty_en_16 = dprio0_cnt_odd_div_even_duty_en_16,
	
	parameter output_clock_frequency_17 = "0 ps",
	parameter enable_output_counter_17 = "true",
	parameter phase_shift_17 = "0 ps",
	parameter duty_cycle_17 = 50,
	parameter c_cnt_coarse_dly_17 = "0 ps",
	parameter c_cnt_fine_dly_17 = "0 ps",
	parameter c_cnt_in_src_17 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_17 = 0,
	parameter c_cnt_prst_17 = 1,
	parameter cnt_fpll_src_17 = "fpll_0",
	parameter dprio0_cnt_bypass_en_17 = "false",
	parameter dprio0_cnt_hi_div_17 = 1,
	parameter dprio0_cnt_lo_div_17 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_17 = "false",
	parameter dprio1_cnt_bypass_en_17 = dprio0_cnt_bypass_en_17,
	parameter dprio1_cnt_hi_div_17 = dprio0_cnt_hi_div_17,
	parameter dprio1_cnt_lo_div_17 = dprio0_cnt_lo_div_17,
	parameter dprio1_cnt_odd_div_even_duty_en_17 = dprio0_cnt_odd_div_even_duty_en_17,

	// arriavgz_pll_dpa_output parameters -- dpa_output 0
	parameter dpa_output_clock_frequency_0 = "0 ps",
	parameter pll_vcoph_div_0 = 1,

	parameter dpa_output_clock_frequency_1 = "0 ps",
	parameter pll_vcoph_div_1 = 1,
	
	// arriavgz_pll_extclk_output parameters -- extclk 0
	parameter enable_extclk_output_0 = "false",
	parameter pll_extclk_cnt_src_0 = "vss",
	parameter pll_extclk_enable_0 = "true",
	parameter pll_extclk_invert_0 = "false",
	
	parameter enable_extclk_output_1 = "false",
	parameter pll_extclk_cnt_src_1 = "vss",
	parameter pll_extclk_enable_1 = "true",
	parameter pll_extclk_invert_1 = "false",
	
	parameter enable_extclk_output_2 = "false",
	parameter pll_extclk_cnt_src_2 = "vss",
	parameter pll_extclk_enable_2 = "true",
	parameter pll_extclk_invert_2 = "false",
	
	parameter enable_extclk_output_3 = "false",
	parameter pll_extclk_cnt_src_3 = "vss",
	parameter pll_extclk_enable_3 = "true",
	parameter pll_extclk_invert_3 = "false",
	
	// arriavgz_pll_dll_output parameters -- dll_output 0
	parameter enable_dll_output_0 = "false",
	parameter pll_dll_src_value_0 = "vss",
	
	parameter enable_dll_output_1 = "false",
	parameter pll_dll_src_value_1 = "vss",

	// arriavgz_pll_lvds_output parameters -- lvds_output 0
	parameter enable_lvds_output_0 = "false",
	parameter pll_loaden_coarse_dly_0 = "0 ps",
	parameter pll_loaden_enable_disable_0 = "true",
	parameter pll_loaden_fine_dly_0 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_0 = "0 ps",
	parameter pll_lvdsclk_enable_disable_0 = "true",
	parameter pll_lvdsclk_fine_dly_0 = "0 ps",

	parameter enable_lvds_output_1 = "false",
	parameter pll_loaden_coarse_dly_1 = "0 ps",
	parameter pll_loaden_enable_disable_1 = "true",
	parameter pll_loaden_fine_dly_1 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_1 = "0 ps",
	parameter pll_lvdsclk_enable_disable_1 = "true",
	parameter pll_lvdsclk_fine_dly_1 = "0 ps",

	parameter enable_lvds_output_2 = "false",
	parameter pll_loaden_coarse_dly_2 = "0 ps",
	parameter pll_loaden_enable_disable_2 = "true",
	parameter pll_loaden_fine_dly_2 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_2 = "0 ps",
	parameter pll_lvdsclk_enable_disable_2 = "true",
	parameter pll_lvdsclk_fine_dly_2 = "0 ps",

	parameter enable_lvds_output_3 = "false",
	parameter pll_loaden_coarse_dly_3 = "0 ps",
	parameter pll_loaden_enable_disable_3 = "true",
	parameter pll_loaden_fine_dly_3 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_3 = "0 ps",
	parameter pll_lvdsclk_enable_disable_3 = "true",
	parameter pll_lvdsclk_fine_dly_3 = "0 ps"
)
(
	// arriavgz_pll_dpa_output pins
	output [7:0] phout_0,
	output [7:0] phout_1,

	// arriavgz_pll_refclk_select pins
	input [number_of_fplls-1:0] adjpllin,	
	input [number_of_fplls-1:0] cclk,
	input [number_of_fplls-1:0] coreclkin,
	input [number_of_fplls-1:0] extswitch,
	input [number_of_fplls-1:0] iqtxrxclkin,
	input [number_of_fplls-1:0] plliqclkin,
	input [number_of_fplls-1:0] rxiqclkin,
	input [3:0] clkin,
	input [1:0] refiqclk_0,
	input [1:0] refiqclk_1,
	output [number_of_fplls-1:0] clk0bad,
	output [number_of_fplls-1:0] clk1bad,
	output [number_of_fplls-1:0] pllclksel,

// arriavgz_pll_reconfig pins
	input [number_of_fplls-1:0] atpgmode,
	input [number_of_fplls-1:0] clk,
	input [number_of_fplls-1:0] fpllcsrtest,
	input [number_of_fplls-1:0] iocsrclkin,
	input [number_of_fplls-1:0] iocsrdatain,
	input [number_of_fplls-1:0] iocsren,
	input [number_of_fplls-1:0] iocsrrstn,
	input [number_of_fplls-1:0] mdiodis,
	input [number_of_fplls-1:0] phaseen,
	input [number_of_fplls-1:0] read,
	input [number_of_fplls-1:0] rstn,
	input [number_of_fplls-1:0] scanen,
	input [number_of_fplls-1:0] sershiftload,
	input [number_of_fplls-1:0] shiftdonei,
	input [number_of_fplls-1:0] updn,
	input [number_of_fplls-1:0] write,
	input [5:0] addr_0,
	input [5:0] addr_1,
	input [1:0] byteen_0,
	input [1:0] byteen_1,
	input [4:0] cntsel_0,
	input [4:0] cntsel_1,
	input [15:0] din_0,
	input [15:0] din_1,
	output [number_of_fplls-1:0] blockselect,
	output [number_of_fplls-1:0] iocsrdataout,
	output [number_of_fplls-1:0] iocsrenbuf,
	output [number_of_fplls-1:0] iocsrrstnbuf,
	output [number_of_fplls-1:0] phasedone,
	output [15:0] dout_0,
	output [15:0] dout_1,
	output [815:0] dprioout_0,
	output [815:0] dprioout_1,

// arriavgz_fractional_pll pins
	input [number_of_fplls-1:0] fbclkfpll,
	input [number_of_fplls-1:0] lvdfbin,
	input [number_of_fplls-1:0] nresync,
	input [number_of_fplls-1:0] pfden,
	input [number_of_fplls-1:0] shiften_fpll,
	input [number_of_fplls-1:0] zdb,
	output [number_of_fplls-1:0] fblvdsout,
	output [number_of_fplls-1:0] lock,
	output [number_of_fplls-1:0] mcntout,
	output [number_of_fplls-1:0] plniotribuf,

// arriavgz_pll_extclk_output pins
	input [number_of_extclks-1:0] clken,
	output [number_of_extclks-1:0] extclk,

// arriavgz_pll_dll_output pins
	input [number_of_dlls-1:0] dll_clkin,
	output [number_of_dlls-1:0] clkout,

// arriavgz_pll_lvds_output pins
	output [number_of_lvds-1:0] loaden,
	output [number_of_lvds-1:0] lvdsclk,

// arriavgz_pll_output_counter pins
	output [number_of_counters-1:0] divclk,
	output [number_of_counters-1:0] cascade_out	
);

////////////////////////////////////////////////////////////////////////////////
// pll_clkin_0_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLKIN_0_SRC_PLL_IQCLK = 4'b1100 ;
localparam PLL_CLKIN_0_SRC_FPLL = 4'b1011 ;
localparam PLL_CLKIN_0_SRC_IQTXRXCLK = 4'b1010 ;
localparam PLL_CLKIN_0_SRC_CMU_IQCLK = 4'b1001 ;
localparam PLL_CLKIN_0_SRC_VSS = 4'b1000 ;
localparam PLL_CLKIN_0_SRC_CLK_3 = 4'b0111 ;
localparam PLL_CLKIN_0_SRC_CLK_2 = 4'b0110 ;
localparam PLL_CLKIN_0_SRC_CLK_1 = 4'b0101 ;
localparam PLL_CLKIN_0_SRC_CLK_0 = 4'b0100 ;
localparam PLL_CLKIN_0_SRC_REF_CLK1 = 4'b0011 ;
localparam PLL_CLKIN_0_SRC_REF_CLK0 = 4'b0010 ;
localparam PLL_CLKIN_0_SRC_ADJ_PLL_CLK = 4'b0001 ;
localparam PLL_CLKIN_0_SRC_CORE_REF_CLK = 4'b0000 ;
localparam local_pll_clkin_0_src_0 = (pll_clkin_0_src_0 == "core_ref_clk") ? PLL_CLKIN_0_SRC_CORE_REF_CLK :
								   (pll_clkin_0_src_0 == "adj_pll_clk") ? PLL_CLKIN_0_SRC_ADJ_PLL_CLK :
								   (pll_clkin_0_src_0 == "ref_clk0") ? PLL_CLKIN_0_SRC_REF_CLK0 :
								   (pll_clkin_0_src_0 == "ref_clk1") ? PLL_CLKIN_0_SRC_REF_CLK1 :
								   (pll_clkin_0_src_0 == "clk_0") ? PLL_CLKIN_0_SRC_CLK_0 :
								   (pll_clkin_0_src_0 == "clk_1") ? PLL_CLKIN_0_SRC_CLK_1 :
								   (pll_clkin_0_src_0 == "clk_2") ? PLL_CLKIN_0_SRC_CLK_2 :
								   (pll_clkin_0_src_0 == "clk_3") ? PLL_CLKIN_0_SRC_CLK_3 :
								   (pll_clkin_0_src_0 == "vss") ? PLL_CLKIN_0_SRC_VSS :
								   (pll_clkin_0_src_0 == "cmu_iqclk") ? PLL_CLKIN_0_SRC_CMU_IQCLK :
								   (pll_clkin_0_src_0 == "iqtxrxclk") ? PLL_CLKIN_0_SRC_IQTXRXCLK :
								   (pll_clkin_0_src_0 == "fpll") ? PLL_CLKIN_0_SRC_FPLL :
								   (pll_clkin_0_src_0 == "pll_iqclk") ? PLL_CLKIN_0_SRC_PLL_IQCLK : PLL_CLKIN_0_SRC_VSS;
localparam local_pll_clkin_0_src_1 = (pll_clkin_0_src_1 == "core_ref_clk") ? PLL_CLKIN_0_SRC_CORE_REF_CLK :
								   (pll_clkin_0_src_1 == "adj_pll_clk") ? PLL_CLKIN_0_SRC_ADJ_PLL_CLK :
								   (pll_clkin_0_src_1 == "ref_clk0") ? PLL_CLKIN_0_SRC_REF_CLK0 :
								   (pll_clkin_0_src_1 == "ref_clk1") ? PLL_CLKIN_0_SRC_REF_CLK1 :
								   (pll_clkin_0_src_1 == "clk_0") ? PLL_CLKIN_0_SRC_CLK_0 :
								   (pll_clkin_0_src_1 == "clk_1") ? PLL_CLKIN_0_SRC_CLK_1 :
								   (pll_clkin_0_src_1 == "clk_2") ? PLL_CLKIN_0_SRC_CLK_2 :
								   (pll_clkin_0_src_1 == "clk_3") ? PLL_CLKIN_0_SRC_CLK_3 :
								   (pll_clkin_0_src_1 == "vss") ? PLL_CLKIN_0_SRC_VSS :
								   (pll_clkin_0_src_1 == "cmu_iqclk") ? PLL_CLKIN_0_SRC_CMU_IQCLK :
								   (pll_clkin_0_src_1 == "iqtxrxclk") ? PLL_CLKIN_0_SRC_IQTXRXCLK :
								   (pll_clkin_0_src_1 == "fpll") ? PLL_CLKIN_0_SRC_FPLL :
								   (pll_clkin_0_src_1 == "pll_iqclk") ? PLL_CLKIN_0_SRC_PLL_IQCLK : PLL_CLKIN_0_SRC_VSS;

								   
////////////////////////////////////////////////////////////////////////////////
// pll_clkin_1_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLKIN_1_SRC_PLL_IQCLK = 4'b1100 ;
localparam PLL_CLKIN_1_SRC_FPLL = 4'b1011 ;
localparam PLL_CLKIN_1_SRC_IQTXRXCLK = 4'b1010 ;
localparam PLL_CLKIN_1_SRC_CMU_IQCLK = 4'b1001 ;
localparam PLL_CLKIN_1_SRC_VSS = 4'b1000 ;
localparam PLL_CLKIN_1_SRC_CLK_3 = 4'b0111 ;
localparam PLL_CLKIN_1_SRC_CLK_2 = 4'b0110 ;
localparam PLL_CLKIN_1_SRC_CLK_1 = 4'b0101 ;
localparam PLL_CLKIN_1_SRC_CLK_0 = 4'b0100 ;
localparam PLL_CLKIN_1_SRC_REF_CLK1 = 4'b0011 ;
localparam PLL_CLKIN_1_SRC_REF_CLK0 = 4'b0010 ;
localparam PLL_CLKIN_1_SRC_ADJ_PLL_CLK = 4'b0001 ;
localparam PLL_CLKIN_1_SRC_CORE_REF_CLK = 4'b0000 ;
localparam local_pll_clkin_1_src_0 = (pll_clkin_1_src_0 == "core_ref_clk") ? PLL_CLKIN_1_SRC_CORE_REF_CLK :
								   (pll_clkin_1_src_0 == "adj_pll_clk") ? PLL_CLKIN_1_SRC_ADJ_PLL_CLK :
								   (pll_clkin_1_src_0 == "ref_clk0") ? PLL_CLKIN_1_SRC_REF_CLK0 :
								   (pll_clkin_1_src_0 == "ref_clk1") ? PLL_CLKIN_1_SRC_REF_CLK1 :
								   (pll_clkin_1_src_0 == "clk_0") ? PLL_CLKIN_1_SRC_CLK_0 :
								   (pll_clkin_1_src_0 == "clk_1") ? PLL_CLKIN_1_SRC_CLK_1 :
								   (pll_clkin_1_src_0 == "clk_2") ? PLL_CLKIN_1_SRC_CLK_2 :
								   (pll_clkin_1_src_0 == "clk_3") ? PLL_CLKIN_1_SRC_CLK_3 :
								   (pll_clkin_1_src_0 == "vss") ? PLL_CLKIN_1_SRC_VSS :
								   (pll_clkin_1_src_0 == "cmu_iqclk") ? PLL_CLKIN_1_SRC_CMU_IQCLK :
								   (pll_clkin_1_src_0 == "iqtxrxclk") ? PLL_CLKIN_1_SRC_IQTXRXCLK :
								   (pll_clkin_1_src_0 == "fpll") ? PLL_CLKIN_1_SRC_FPLL :
								   (pll_clkin_1_src_0 == "pll_iqclk") ? PLL_CLKIN_1_SRC_PLL_IQCLK : PLL_CLKIN_1_SRC_VSS;
localparam local_pll_clkin_1_src_1 = (pll_clkin_1_src_1 == "core_ref_clk") ? PLL_CLKIN_1_SRC_CORE_REF_CLK :
								   (pll_clkin_1_src_1 == "adj_pll_clk") ? PLL_CLKIN_1_SRC_ADJ_PLL_CLK :
								   (pll_clkin_1_src_1 == "ref_clk0") ? PLL_CLKIN_1_SRC_REF_CLK0 :
								   (pll_clkin_1_src_1 == "ref_clk1") ? PLL_CLKIN_1_SRC_REF_CLK1 :
								   (pll_clkin_1_src_1 == "clk_0") ? PLL_CLKIN_1_SRC_CLK_0 :
								   (pll_clkin_1_src_1 == "clk_1") ? PLL_CLKIN_1_SRC_CLK_1 :
								   (pll_clkin_1_src_1 == "clk_2") ? PLL_CLKIN_1_SRC_CLK_2 :
								   (pll_clkin_1_src_1 == "clk_3") ? PLL_CLKIN_1_SRC_CLK_3 :
								   (pll_clkin_1_src_1 == "vss") ? PLL_CLKIN_1_SRC_VSS :
								   (pll_clkin_1_src_1 == "cmu_iqclk") ? PLL_CLKIN_1_SRC_CMU_IQCLK :
								   (pll_clkin_1_src_1 == "iqtxrxclk") ? PLL_CLKIN_1_SRC_IQTXRXCLK :
								   (pll_clkin_1_src_1 == "fpll") ? PLL_CLKIN_1_SRC_FPLL :
								   (pll_clkin_1_src_1 == "pll_iqclk") ? PLL_CLKIN_1_SRC_PLL_IQCLK : PLL_CLKIN_1_SRC_VSS;
								   
////////////////////////////////////////////////////////////////////////////////
// pll_clk_sw_dly_setting
////////////////////////////////////////////////////////////////////////////////
localparam SWITCHOVER_DLY_SETTING = 3'b000 ;
localparam local_pll_clk_sw_dly_0 = pll_clk_sw_dly_0;
localparam local_pll_clk_sw_dly_1 = pll_clk_sw_dly_1;
localparam local_pll_clk_sw_dly_setting_0 = pll_clk_sw_dly_0;
localparam local_pll_clk_sw_dly_setting_1 = pll_clk_sw_dly_1;

////////////////////////////////////////////////////////////////////////////////
// pll_clk_loss_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLK_LOSS_SW_ENABLED = 1'b1 ;
localparam PLL_CLK_LOSS_SW_BYPS = 1'b0 ;
localparam local_pll_clk_loss_sw_en_0 = (pll_clk_loss_sw_en_0 == "false") ? PLL_CLK_LOSS_SW_BYPS : PLL_CLK_LOSS_SW_ENABLED;
localparam local_pll_clk_loss_sw_en_1 = (pll_clk_loss_sw_en_1 == "false") ? PLL_CLK_LOSS_SW_BYPS : PLL_CLK_LOSS_SW_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_manu_clk_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_MANU_CLK_SW_ENABLED = 1'b1 ;
localparam PLL_MANU_CLK_SW_DISABLED = 1'b0 ;
localparam local_pll_manu_clk_sw_en_0 = (pll_manu_clk_sw_en_0 == "false") ? PLL_MANU_CLK_SW_DISABLED : PLL_MANU_CLK_SW_ENABLED;
localparam local_pll_manu_clk_sw_en_1 = (pll_manu_clk_sw_en_1 == "false") ? PLL_MANU_CLK_SW_DISABLED : PLL_MANU_CLK_SW_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_auto_clk_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_AUTO_CLK_SW_ENABLED = 1'b1 ;
localparam PLL_AUTO_CLK_SW_DISABLED = 1'b0 ;
localparam local_pll_auto_clk_sw_en_0 = (pll_auto_clk_sw_en_0 == "false") ? PLL_AUTO_CLK_SW_DISABLED : PLL_AUTO_CLK_SW_ENABLED; ////////////////////////////////////////////////////////////////////////////////
localparam local_pll_auto_clk_sw_en_1 = (pll_auto_clk_sw_en_1 == "false") ? PLL_AUTO_CLK_SW_DISABLED : PLL_AUTO_CLK_SW_ENABLED; ////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph0_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH0_EN = 1'b1 ;
localparam PLL_VCO_PH0_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph0_en_0 = (pll_vco_ph0_en_0 == "false") ? PLL_VCO_PH0_DIS_EN : PLL_VCO_PH0_EN;
localparam local_pll_vco_ph0_en_1 = (pll_vco_ph0_en_1 == "false") ? PLL_VCO_PH0_DIS_EN : PLL_VCO_PH0_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph1_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH1_EN = 1'b1 ;
localparam PLL_VCO_PH1_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph1_en_0 = (pll_vco_ph1_en_0 == "false") ? PLL_VCO_PH1_DIS_EN : PLL_VCO_PH1_EN;
localparam local_pll_vco_ph1_en_1 = (pll_vco_ph1_en_1 == "false") ? PLL_VCO_PH1_DIS_EN : PLL_VCO_PH1_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph2_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH2_EN = 1'b1 ;
localparam PLL_VCO_PH2_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph2_en_0 = (pll_vco_ph2_en_0 == "false") ? PLL_VCO_PH2_DIS_EN : PLL_VCO_PH2_EN;
localparam local_pll_vco_ph2_en_1 = (pll_vco_ph2_en_1 == "false") ? PLL_VCO_PH2_DIS_EN : PLL_VCO_PH2_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph3_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH3_EN = 1'b1 ;
localparam PLL_VCO_PH3_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph3_en_0 = (pll_vco_ph3_en_0 == "false") ? PLL_VCO_PH3_DIS_EN : PLL_VCO_PH3_EN;
localparam local_pll_vco_ph3_en_1 = (pll_vco_ph3_en_1 == "false") ? PLL_VCO_PH3_DIS_EN : PLL_VCO_PH3_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph4_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH4_EN = 1'b1 ;
localparam PLL_VCO_PH4_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph4_en_0 = (pll_vco_ph4_en_0 == "false") ? PLL_VCO_PH4_DIS_EN : PLL_VCO_PH4_EN;
localparam local_pll_vco_ph4_en_1 = (pll_vco_ph4_en_1 == "false") ? PLL_VCO_PH4_DIS_EN : PLL_VCO_PH4_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph5_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH5_EN = 1'b1 ;
localparam PLL_VCO_PH5_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph5_en_0 = (pll_vco_ph5_en_0 == "false") ? PLL_VCO_PH5_DIS_EN : PLL_VCO_PH5_EN;
localparam local_pll_vco_ph5_en_1 = (pll_vco_ph5_en_1 == "false") ? PLL_VCO_PH5_DIS_EN : PLL_VCO_PH5_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph6_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH6_EN = 1'b1 ;
localparam PLL_VCO_PH6_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph6_en_0 = (pll_vco_ph6_en_0 == "false") ? PLL_VCO_PH6_DIS_EN : PLL_VCO_PH6_EN;
localparam local_pll_vco_ph6_en_1 = (pll_vco_ph6_en_1 == "false") ? PLL_VCO_PH6_DIS_EN : PLL_VCO_PH6_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph7_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH7_EN = 1'b1 ;
localparam PLL_VCO_PH7_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph7_en_0 = (pll_vco_ph7_en_0 == "false") ? PLL_VCO_PH7_DIS_EN : PLL_VCO_PH7_EN;
localparam local_pll_vco_ph7_en_1 = (pll_vco_ph7_en_1 == "false") ? PLL_VCO_PH7_DIS_EN : PLL_VCO_PH7_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_enable
////////////////////////////////////////////////////////////////////////////////
localparam PLL_ENABLED = 1'b1 ;
localparam PLL_DISABLED = 1'b0 ;
localparam local_pll_enable_0 = (pll_enable_0 == "true") ? PLL_ENABLED : PLL_DISABLED;
localparam local_pll_enable_1 = (pll_enable_1 == "true") ? PLL_ENABLED : PLL_DISABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_ctrl_override_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CTRL_ENABLE = 1'b1 ;
localparam PLL_CTRL_DISABLE = 1'b0 ;
localparam local_pll_ctrl_override_setting_0 = (pll_ctrl_override_setting_0 == "false") ? PLL_CTRL_DISABLE : PLL_CTRL_ENABLE;
localparam local_pll_ctrl_override_setting_1 = (pll_ctrl_override_setting_1 == "false") ? PLL_CTRL_DISABLE : PLL_CTRL_ENABLE;

////////////////////////////////////////////////////////////////////////////////
// pll_fbclk_mux_1
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FBCLK_MUX_1_FBCLK_FPLL = 2'b11 ;
localparam PLL_FBCLK_MUX_1_LVDS = 2'b10 ;
localparam PLL_FBCLK_MUX_1_ZBD = 2'b01 ;
localparam PLL_FBCLK_MUX_1_GLB = 2'b00 ;
localparam local_pll_fbclk_mux_1_0 = (pll_fbclk_mux_1_0 == "glb") ? PLL_FBCLK_MUX_1_GLB :
								   (pll_fbclk_mux_1_0 == "zbd") ? PLL_FBCLK_MUX_1_ZBD :
								   (pll_fbclk_mux_1_0 == "lvds") ? PLL_FBCLK_MUX_1_LVDS : PLL_FBCLK_MUX_1_FBCLK_FPLL;
localparam local_pll_fbclk_mux_1_1 = (pll_fbclk_mux_1_1 == "glb") ? PLL_FBCLK_MUX_1_GLB :
								   (pll_fbclk_mux_1_1 == "zbd") ? PLL_FBCLK_MUX_1_ZBD :
								   (pll_fbclk_mux_1_1 == "lvds") ? PLL_FBCLK_MUX_1_LVDS : PLL_FBCLK_MUX_1_FBCLK_FPLL;

////////////////////////////////////////////////////////////////////////////////
// pll_fbclk_mux_2
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FBCLK_MUX_2_M_CNT = 1'b1 ;
localparam PLL_FBCLK_MUX_2_FB_1 = 1'b0 ;
localparam local_pll_fbclk_mux_2_0 = (pll_fbclk_mux_2_0 == "fb_1") ? PLL_FBCLK_MUX_2_FB_1 : PLL_FBCLK_MUX_2_M_CNT;
localparam local_pll_fbclk_mux_2_1 = (pll_fbclk_mux_2_1 == "fb_1") ? PLL_FBCLK_MUX_2_FB_1 : PLL_FBCLK_MUX_2_M_CNT;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_BYPASS_ENABLED = 1'b1 ;
localparam PLL_N_CNT_DIV_ENABLED = 1'b0 ;
localparam local_pll_n_cnt_bypass_en_0 = (pll_n_cnt_bypass_en_0 == "false") ? PLL_N_CNT_DIV_ENABLED : PLL_N_CNT_BYPASS_ENABLED;
localparam local_pll_n_cnt_bypass_en_1 = (pll_n_cnt_bypass_en_1 == "false") ? PLL_N_CNT_DIV_ENABLED : PLL_N_CNT_BYPASS_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_lo_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_LO_VALUE = 8'h01 ;
localparam local_pll_n_cnt_lo_div_0 = pll_n_cnt_lo_div_0;
localparam local_pll_n_cnt_lo_div_setting_0 = pll_n_cnt_lo_div_0;
localparam local_pll_n_cnt_lo_div_1 = pll_n_cnt_lo_div_1;
localparam local_pll_n_cnt_lo_div_setting_1 = pll_n_cnt_lo_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_hi_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_HI_VALUE = 8'h01 ;
localparam local_pll_n_cnt_hi_div_0 = pll_n_cnt_hi_div_0;
localparam local_pll_n_cnt_hi_div_setting_0 = pll_n_cnt_hi_div_0;
localparam local_pll_n_cnt_hi_div_1 = pll_n_cnt_hi_div_1;
localparam local_pll_n_cnt_hi_div_setting_1 = pll_n_cnt_hi_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_odd_div_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_EVEN_DUTY_ENABLED = 1'b1 ;
localparam PLL_N_CNT_EVEN_DUTY_DISABLED = 1'b0 ;
localparam local_pll_n_cnt_odd_div_duty_en_0 = (pll_n_cnt_odd_div_duty_en_0 == "false") ? PLL_N_CNT_EVEN_DUTY_DISABLED : PLL_N_CNT_EVEN_DUTY_ENABLED;
localparam local_pll_n_cnt_odd_div_duty_en_1 = (pll_n_cnt_odd_div_duty_en_1 == "false") ? PLL_N_CNT_EVEN_DUTY_DISABLED : PLL_N_CNT_EVEN_DUTY_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_tclk_sel
////////////////////////////////////////////////////////////////////////////////
localparam PLL_TCLK_M_SRC = 1'b1 ;
localparam PLL_TCLK_N_SRC = 1'b0 ;
localparam local_pll_tclk_sel_0 = (pll_tclk_sel_0 == "cdb_pll_tclk_sel_m_src") ? PLL_TCLK_M_SRC : PLL_TCLK_N_SRC;
localparam local_pll_tclk_sel_1 = (pll_tclk_sel_1 == "cdb_pll_tclk_sel_m_src") ? PLL_TCLK_M_SRC : PLL_TCLK_N_SRC;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_odd_div_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_EVEN_DUTY_ENABLED = 1'b1 ;
localparam PLL_M_CNT_EVEN_DUTY_DISABLED = 1'b0 ;
localparam local_pll_m_cnt_odd_div_duty_en_0 = (pll_m_cnt_odd_div_duty_en_0 == "false") ? PLL_M_CNT_EVEN_DUTY_DISABLED : PLL_M_CNT_EVEN_DUTY_ENABLED;
localparam local_pll_m_cnt_odd_div_duty_en_1 = (pll_m_cnt_odd_div_duty_en_1 == "false") ? PLL_M_CNT_EVEN_DUTY_DISABLED : PLL_M_CNT_EVEN_DUTY_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_BYPASS_ENABLED = 1'b1 ;
localparam PLL_M_CNT_DIV_ENABLED = 1'b0 ;
localparam local_pll_m_cnt_bypass_en_0 = (pll_m_cnt_bypass_en_0 == "false") ? PLL_M_CNT_DIV_ENABLED : PLL_M_CNT_BYPASS_ENABLED;
localparam local_pll_m_cnt_bypass_en_1 = (pll_m_cnt_bypass_en_1 == "false") ? PLL_M_CNT_DIV_ENABLED : PLL_M_CNT_BYPASS_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_hi_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_HI_VALUE = 8'h01 ;
localparam local_pll_m_cnt_hi_div_0 = pll_m_cnt_hi_div_0;
localparam local_pll_m_cnt_hi_div_setting_0 = pll_m_cnt_hi_div_0;
localparam local_pll_m_cnt_hi_div_1 = pll_m_cnt_hi_div_1;
localparam local_pll_m_cnt_hi_div_setting_1 = pll_m_cnt_hi_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_in_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_IN_SRC_VSS = 2'b11 ;
localparam PLL_M_CNT_IN_SRC_TEST_CLK = 2'b10 ;
localparam PLL_M_CNT_IN_SRC_FBLVDS = 2'b01 ;
localparam PLL_M_CNT_IN_SRC_PH_MUX_CLK = 2'b00 ;
localparam local_pll_m_cnt_in_src_0 = (pll_m_cnt_in_src_0 == "ph_mux_clk") ? PLL_M_CNT_IN_SRC_PH_MUX_CLK :
									(pll_m_cnt_in_src_0 == "fblvds") ? PLL_M_CNT_IN_SRC_FBLVDS :
									(pll_m_cnt_in_src_0 == "test_clk") ? PLL_M_CNT_IN_SRC_TEST_CLK : PLL_M_CNT_IN_SRC_VSS;
localparam local_pll_m_cnt_in_src_1 = (pll_m_cnt_in_src_1 == "ph_mux_clk") ? PLL_M_CNT_IN_SRC_PH_MUX_CLK :
									(pll_m_cnt_in_src_1 == "fblvds") ? PLL_M_CNT_IN_SRC_FBLVDS :
									(pll_m_cnt_in_src_1 == "test_clk") ? PLL_M_CNT_IN_SRC_TEST_CLK : PLL_M_CNT_IN_SRC_VSS;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_lo_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_LO_VALUE = 8'h01 ;
localparam local_pll_m_cnt_lo_div_0 = pll_m_cnt_lo_div_0;
localparam local_pll_m_cnt_lo_div_setting_0 = pll_m_cnt_lo_div_0;
localparam local_pll_m_cnt_lo_div_1 = pll_m_cnt_lo_div_1;
localparam local_pll_m_cnt_lo_div_setting_1 = pll_m_cnt_lo_div_1;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_prst_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_PRST_VALUE = 8'h01 ;
localparam local_pll_m_cnt_prst_0 = pll_m_cnt_prst_0;
localparam local_pll_m_cnt_prst_setting_0 = pll_m_cnt_prst_0;
localparam local_pll_m_cnt_prst_1 = pll_m_cnt_prst_1;
localparam local_pll_m_cnt_prst_setting_1 = pll_m_cnt_prst_1;

////////////////////////////////////////////////////////////////////////////////
// pll_unlock_fltr_cfg_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_UNLOCK_COUNTER_SETTING = 3'b000 ;
localparam local_pll_unlock_fltr_cfg_0 = pll_unlock_fltr_cfg_0;
localparam local_pll_unlock_fltr_cfg_setting_0 = pll_unlock_fltr_cfg_0;
localparam local_pll_unlock_fltr_cfg_1 = pll_unlock_fltr_cfg_1;
localparam local_pll_unlock_fltr_cfg_setting_1 = pll_unlock_fltr_cfg_1;

////////////////////////////////////////////////////////////////////////////////
// pll_lock_fltr_cfg_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_LOCK_COUNTER_SETTING = 12'h001 ;
localparam local_pll_lock_fltr_cfg_0 = pll_lock_fltr_cfg_0;
localparam local_pll_lock_fltr_cfg_setting_0 = pll_lock_fltr_cfg_0;
localparam local_pll_lock_fltr_cfg_1 = pll_lock_fltr_cfg_1;
localparam local_pll_lock_fltr_cfg_setting_1 = pll_lock_fltr_cfg_1;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_in_src
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_IN_SRC_TEST_CLK1 = 2'b11 ;
localparam C_CNT_IN_SRC_TEST_CLK0 = 2'b10 ;
localparam C_CNT_IN_SRC_CSCD_CLK = 2'b01 ;
localparam C_CNT_IN_SRC_PH_MUX_CLK = 2'b00 ;
localparam local_c_cnt_in_src_0 = (c_cnt_in_src_0 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_0 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_0 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_1 = (c_cnt_in_src_1 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_1 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_1 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_2 = (c_cnt_in_src_2 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_2 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_2 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_3 = (c_cnt_in_src_3 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_3 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_3 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_4 = (c_cnt_in_src_4 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_4 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_4 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_5 = (c_cnt_in_src_5 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_5 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_5 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_6 = (c_cnt_in_src_6 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_6 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_6 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_7 = (c_cnt_in_src_7 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_7 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_7 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_8 = (c_cnt_in_src_8 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_8 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_8 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_9 = (c_cnt_in_src_9 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_9 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_9 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_10 = (c_cnt_in_src_10 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_10 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_10 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_11 = (c_cnt_in_src_11 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_11 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_11 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_12 = (c_cnt_in_src_12 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_12 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_12 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_13 = (c_cnt_in_src_13 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_13 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_13 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_14 = (c_cnt_in_src_14 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_14 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_14 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_15 = (c_cnt_in_src_15 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_15 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_15 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_16 = (c_cnt_in_src_16 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_16 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_16 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_17 = (c_cnt_in_src_17 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_17 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_17 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;

////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_DIV_ENABLED = 0 ;
localparam local_dprio0_cnt_bypass_en_0 = (dprio0_cnt_bypass_en_0 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_0 = (dprio0_cnt_bypass_en_0 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_1 = (dprio0_cnt_bypass_en_1 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_1 = (dprio0_cnt_bypass_en_1 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_2 = (dprio0_cnt_bypass_en_2 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_2 = (dprio0_cnt_bypass_en_2 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_3 = (dprio0_cnt_bypass_en_3 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_3 = (dprio0_cnt_bypass_en_3 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_4 = (dprio0_cnt_bypass_en_4 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_4 = (dprio0_cnt_bypass_en_4 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_5 = (dprio0_cnt_bypass_en_5 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_5 = (dprio0_cnt_bypass_en_5 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_6 = (dprio0_cnt_bypass_en_6 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_6 = (dprio0_cnt_bypass_en_6 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_7 = (dprio0_cnt_bypass_en_7 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_7 = (dprio0_cnt_bypass_en_7 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_8 = (dprio0_cnt_bypass_en_8 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_8 = (dprio0_cnt_bypass_en_8 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_9 = (dprio0_cnt_bypass_en_9 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_9 = (dprio0_cnt_bypass_en_9 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_10 = (dprio0_cnt_bypass_en_10 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_10 = (dprio0_cnt_bypass_en_10 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_11 = (dprio0_cnt_bypass_en_11 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_11 = (dprio0_cnt_bypass_en_11 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_12 = (dprio0_cnt_bypass_en_12 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_12 = (dprio0_cnt_bypass_en_12 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_13 = (dprio0_cnt_bypass_en_13 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_13 = (dprio0_cnt_bypass_en_13 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_14 = (dprio0_cnt_bypass_en_14 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_14 = (dprio0_cnt_bypass_en_14 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_15 = (dprio0_cnt_bypass_en_15 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_15 = (dprio0_cnt_bypass_en_15 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_16 = (dprio0_cnt_bypass_en_16 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_16 = (dprio0_cnt_bypass_en_16 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_17 = (dprio0_cnt_bypass_en_17 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_17 = (dprio0_cnt_bypass_en_17 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_prst
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_PRST_VALUE = 1 ;
localparam local_c_cnt_prst_0 = c_cnt_prst_0;
localparam local_c_cnt_prst_user_0 = c_cnt_prst_0;
localparam local_c_cnt_prst_1 = c_cnt_prst_1;
localparam local_c_cnt_prst_user_1 = c_cnt_prst_1;
localparam local_c_cnt_prst_2 = c_cnt_prst_2;
localparam local_c_cnt_prst_user_2 = c_cnt_prst_2;
localparam local_c_cnt_prst_3 = c_cnt_prst_3;
localparam local_c_cnt_prst_user_3 = c_cnt_prst_3;
localparam local_c_cnt_prst_4 = c_cnt_prst_4;
localparam local_c_cnt_prst_user_4 = c_cnt_prst_4;
localparam local_c_cnt_prst_5 = c_cnt_prst_5;
localparam local_c_cnt_prst_user_5 = c_cnt_prst_5;
localparam local_c_cnt_prst_6 = c_cnt_prst_6;
localparam local_c_cnt_prst_user_6 = c_cnt_prst_6;
localparam local_c_cnt_prst_7 = c_cnt_prst_7;
localparam local_c_cnt_prst_user_7 = c_cnt_prst_7;
localparam local_c_cnt_prst_8 = c_cnt_prst_8;
localparam local_c_cnt_prst_user_8 = c_cnt_prst_8;
localparam local_c_cnt_prst_9 = c_cnt_prst_9;
localparam local_c_cnt_prst_user_9 = c_cnt_prst_9;
localparam local_c_cnt_prst_10 = c_cnt_prst_10;
localparam local_c_cnt_prst_user_10 = c_cnt_prst_10;
localparam local_c_cnt_prst_11 = c_cnt_prst_11;
localparam local_c_cnt_prst_user_11 = c_cnt_prst_11;
localparam local_c_cnt_prst_12 = c_cnt_prst_12;
localparam local_c_cnt_prst_user_12 = c_cnt_prst_12;
localparam local_c_cnt_prst_13 = c_cnt_prst_13;
localparam local_c_cnt_prst_user_13 = c_cnt_prst_13;
localparam local_c_cnt_prst_14 = c_cnt_prst_14;
localparam local_c_cnt_prst_user_14 = c_cnt_prst_14;
localparam local_c_cnt_prst_15 = c_cnt_prst_15;
localparam local_c_cnt_prst_user_15 = c_cnt_prst_15;
localparam local_c_cnt_prst_16 = c_cnt_prst_16;
localparam local_c_cnt_prst_user_16 = c_cnt_prst_16;
localparam local_c_cnt_prst_17 = c_cnt_prst_17;
localparam local_c_cnt_prst_user_17 = c_cnt_prst_17;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_ph_mux_prst
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_PH_MUX_PRST_VALUE = 0 ;
localparam local_c_cnt_ph_mux_prst_0 = c_cnt_ph_mux_prst_0;
localparam local_c_cnt_ph_mux_prst_user_0 = c_cnt_ph_mux_prst_0;
localparam local_c_cnt_ph_mux_prst_1 = c_cnt_ph_mux_prst_1;
localparam local_c_cnt_ph_mux_prst_user_1 = c_cnt_ph_mux_prst_1;
localparam local_c_cnt_ph_mux_prst_2 = c_cnt_ph_mux_prst_2;
localparam local_c_cnt_ph_mux_prst_user_2 = c_cnt_ph_mux_prst_2;
localparam local_c_cnt_ph_mux_prst_3 = c_cnt_ph_mux_prst_3;
localparam local_c_cnt_ph_mux_prst_user_3 = c_cnt_ph_mux_prst_3;
localparam local_c_cnt_ph_mux_prst_4 = c_cnt_ph_mux_prst_4;
localparam local_c_cnt_ph_mux_prst_user_4 = c_cnt_ph_mux_prst_4;
localparam local_c_cnt_ph_mux_prst_5 = c_cnt_ph_mux_prst_5;
localparam local_c_cnt_ph_mux_prst_user_5 = c_cnt_ph_mux_prst_5;
localparam local_c_cnt_ph_mux_prst_6 = c_cnt_ph_mux_prst_6;
localparam local_c_cnt_ph_mux_prst_user_6 = c_cnt_ph_mux_prst_6;
localparam local_c_cnt_ph_mux_prst_7 = c_cnt_ph_mux_prst_7;
localparam local_c_cnt_ph_mux_prst_user_7 = c_cnt_ph_mux_prst_7;
localparam local_c_cnt_ph_mux_prst_8 = c_cnt_ph_mux_prst_8;
localparam local_c_cnt_ph_mux_prst_user_8 = c_cnt_ph_mux_prst_8;
localparam local_c_cnt_ph_mux_prst_9 = c_cnt_ph_mux_prst_9;
localparam local_c_cnt_ph_mux_prst_user_9 = c_cnt_ph_mux_prst_9;
localparam local_c_cnt_ph_mux_prst_10 = c_cnt_ph_mux_prst_10;
localparam local_c_cnt_ph_mux_prst_user_10 = c_cnt_ph_mux_prst_10;
localparam local_c_cnt_ph_mux_prst_11 = c_cnt_ph_mux_prst_11;
localparam local_c_cnt_ph_mux_prst_user_11 = c_cnt_ph_mux_prst_11;
localparam local_c_cnt_ph_mux_prst_12 = c_cnt_ph_mux_prst_12;
localparam local_c_cnt_ph_mux_prst_user_12 = c_cnt_ph_mux_prst_12;
localparam local_c_cnt_ph_mux_prst_13 = c_cnt_ph_mux_prst_13;
localparam local_c_cnt_ph_mux_prst_user_13 = c_cnt_ph_mux_prst_13;
localparam local_c_cnt_ph_mux_prst_14 = c_cnt_ph_mux_prst_14;
localparam local_c_cnt_ph_mux_prst_user_14 = c_cnt_ph_mux_prst_14;
localparam local_c_cnt_ph_mux_prst_15 = c_cnt_ph_mux_prst_15;
localparam local_c_cnt_ph_mux_prst_user_15 = c_cnt_ph_mux_prst_15;
localparam local_c_cnt_ph_mux_prst_16 = c_cnt_ph_mux_prst_16;
localparam local_c_cnt_ph_mux_prst_user_16 = c_cnt_ph_mux_prst_16;
localparam local_c_cnt_ph_mux_prst_17 = c_cnt_ph_mux_prst_17;
localparam local_c_cnt_ph_mux_prst_user_17 = c_cnt_ph_mux_prst_17;

/////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_hi_div
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_HI_DIV_VALUE = 0 ;
localparam local_dprio0_cnt_hi_div_0 = dprio0_cnt_hi_div_0;
localparam local_dprio0_cnt_hi_div_user_0 = dprio0_cnt_hi_div_0;
localparam local_dprio0_cnt_hi_div_1 = dprio0_cnt_hi_div_1;
localparam local_dprio0_cnt_hi_div_user_1 = dprio0_cnt_hi_div_1;
localparam local_dprio0_cnt_hi_div_2 = dprio0_cnt_hi_div_2;
localparam local_dprio0_cnt_hi_div_user_2 = dprio0_cnt_hi_div_2;
localparam local_dprio0_cnt_hi_div_3 = dprio0_cnt_hi_div_3;
localparam local_dprio0_cnt_hi_div_user_3 = dprio0_cnt_hi_div_3;
localparam local_dprio0_cnt_hi_div_4 = dprio0_cnt_hi_div_4;
localparam local_dprio0_cnt_hi_div_user_4 = dprio0_cnt_hi_div_4;
localparam local_dprio0_cnt_hi_div_5 = dprio0_cnt_hi_div_5;
localparam local_dprio0_cnt_hi_div_user_5 = dprio0_cnt_hi_div_5;
localparam local_dprio0_cnt_hi_div_6 = dprio0_cnt_hi_div_6;
localparam local_dprio0_cnt_hi_div_user_6 = dprio0_cnt_hi_div_6;
localparam local_dprio0_cnt_hi_div_7 = dprio0_cnt_hi_div_7;
localparam local_dprio0_cnt_hi_div_user_7 = dprio0_cnt_hi_div_7;
localparam local_dprio0_cnt_hi_div_8 = dprio0_cnt_hi_div_8;
localparam local_dprio0_cnt_hi_div_user_8 = dprio0_cnt_hi_div_8;
localparam local_dprio0_cnt_hi_div_9 = dprio0_cnt_hi_div_9;
localparam local_dprio0_cnt_hi_div_user_9 = dprio0_cnt_hi_div_9;
localparam local_dprio0_cnt_hi_div_10 = dprio0_cnt_hi_div_10;
localparam local_dprio0_cnt_hi_div_user_10 = dprio0_cnt_hi_div_10;
localparam local_dprio0_cnt_hi_div_11 = dprio0_cnt_hi_div_11;
localparam local_dprio0_cnt_hi_div_user_11 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_12 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_user_12 = dprio0_cnt_hi_div_12;
localparam local_dprio0_cnt_hi_div_13 = dprio0_cnt_hi_div_13;
localparam local_dprio0_cnt_hi_div_user_13 = dprio0_cnt_hi_div_13;
localparam local_dprio0_cnt_hi_div_14 = dprio0_cnt_hi_div_14;
localparam local_dprio0_cnt_hi_div_user_14 = dprio0_cnt_hi_div_14;
localparam local_dprio0_cnt_hi_div_15 = dprio0_cnt_hi_div_15;
localparam local_dprio0_cnt_hi_div_user_15 = dprio0_cnt_hi_div_15;
localparam local_dprio0_cnt_hi_div_16 = dprio0_cnt_hi_div_16;
localparam local_dprio0_cnt_hi_div_user_16 = dprio0_cnt_hi_div_16;
localparam local_dprio0_cnt_hi_div_17 = dprio0_cnt_hi_div_17;
localparam local_dprio0_cnt_hi_div_user_17 = dprio0_cnt_hi_div_17;

///////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_lo_div
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_LO_DIV_VALUE = 0 ;
localparam local_dprio0_cnt_lo_div_0 = dprio0_cnt_lo_div_0;
localparam local_dprio0_cnt_lo_div_user_0 = dprio0_cnt_lo_div_0;
localparam local_dprio0_cnt_lo_div_1 = dprio0_cnt_lo_div_1;
localparam local_dprio0_cnt_lo_div_user_1 = dprio0_cnt_lo_div_1;
localparam local_dprio0_cnt_lo_div_2 = dprio0_cnt_lo_div_2;
localparam local_dprio0_cnt_lo_div_user_2 = dprio0_cnt_lo_div_2;
localparam local_dprio0_cnt_lo_div_3 = dprio0_cnt_lo_div_3;
localparam local_dprio0_cnt_lo_div_user_3 = dprio0_cnt_lo_div_3;
localparam local_dprio0_cnt_lo_div_4 = dprio0_cnt_lo_div_4;
localparam local_dprio0_cnt_lo_div_user_4 = dprio0_cnt_lo_div_4;
localparam local_dprio0_cnt_lo_div_5 = dprio0_cnt_lo_div_5;
localparam local_dprio0_cnt_lo_div_user_5 = dprio0_cnt_lo_div_5;
localparam local_dprio0_cnt_lo_div_6 = dprio0_cnt_lo_div_6;
localparam local_dprio0_cnt_lo_div_user_6 = dprio0_cnt_lo_div_6;
localparam local_dprio0_cnt_lo_div_7 = dprio0_cnt_lo_div_7;
localparam local_dprio0_cnt_lo_div_user_7 = dprio0_cnt_lo_div_7;
localparam local_dprio0_cnt_lo_div_8 = dprio0_cnt_lo_div_8;
localparam local_dprio0_cnt_lo_div_user_8 = dprio0_cnt_lo_div_8;
localparam local_dprio0_cnt_lo_div_9 = dprio0_cnt_lo_div_9;
localparam local_dprio0_cnt_lo_div_user_9 = dprio0_cnt_lo_div_9;
localparam local_dprio0_cnt_lo_div_10 = dprio0_cnt_lo_div_10;
localparam local_dprio0_cnt_lo_div_user_10 = dprio0_cnt_lo_div_10;
localparam local_dprio0_cnt_lo_div_11 = dprio0_cnt_lo_div_11;
localparam local_dprio0_cnt_lo_div_user_11 = dprio0_cnt_lo_div_11;
localparam local_dprio0_cnt_lo_div_12 = dprio0_cnt_lo_div_12;
localparam local_dprio0_cnt_lo_div_user_12 = dprio0_cnt_lo_div_12;
localparam local_dprio0_cnt_lo_div_13 = dprio0_cnt_lo_div_13;
localparam local_dprio0_cnt_lo_div_user_13 = dprio0_cnt_lo_div_13;
localparam local_dprio0_cnt_lo_div_14 = dprio0_cnt_lo_div_14;
localparam local_dprio0_cnt_lo_div_user_14 = dprio0_cnt_lo_div_14;
localparam local_dprio0_cnt_lo_div_15 = dprio0_cnt_lo_div_15;
localparam local_dprio0_cnt_lo_div_user_15 = dprio0_cnt_lo_div_15;
localparam local_dprio0_cnt_lo_div_16 = dprio0_cnt_lo_div_16;
localparam local_dprio0_cnt_lo_div_user_16 = dprio0_cnt_lo_div_16;
localparam local_dprio0_cnt_lo_div_17 = dprio0_cnt_lo_div_17;
localparam local_dprio0_cnt_lo_div_user_17 = dprio0_cnt_lo_div_17;

////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_odd_div_even_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED = 0 ;
localparam local_dprio0_cnt_odd_div_even_duty_en_0 = (dprio0_cnt_odd_div_even_duty_en_0 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_0 = (dprio0_cnt_odd_div_even_duty_en_0 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_1 = (dprio0_cnt_odd_div_even_duty_en_1 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_1 = (dprio0_cnt_odd_div_even_duty_en_1 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_2 = (dprio0_cnt_odd_div_even_duty_en_2 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_2 = (dprio0_cnt_odd_div_even_duty_en_2 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_3 = (dprio0_cnt_odd_div_even_duty_en_3 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_3 = (dprio0_cnt_odd_div_even_duty_en_3 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_4 = (dprio0_cnt_odd_div_even_duty_en_4 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_4 = (dprio0_cnt_odd_div_even_duty_en_4 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_5 = (dprio0_cnt_odd_div_even_duty_en_5 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_5 = (dprio0_cnt_odd_div_even_duty_en_5 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_6 = (dprio0_cnt_odd_div_even_duty_en_6 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_6 = (dprio0_cnt_odd_div_even_duty_en_6 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_7 = (dprio0_cnt_odd_div_even_duty_en_7 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_7 = (dprio0_cnt_odd_div_even_duty_en_7 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_8 = (dprio0_cnt_odd_div_even_duty_en_8 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_8 = (dprio0_cnt_odd_div_even_duty_en_8 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_9 = (dprio0_cnt_odd_div_even_duty_en_9 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_9 = (dprio0_cnt_odd_div_even_duty_en_9 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_10 = (dprio0_cnt_odd_div_even_duty_en_10 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_10 = (dprio0_cnt_odd_div_even_duty_en_10 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_11 = (dprio0_cnt_odd_div_even_duty_en_11 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_11 = (dprio0_cnt_odd_div_even_duty_en_11 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_12 = (dprio0_cnt_odd_div_even_duty_en_12 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_12 = (dprio0_cnt_odd_div_even_duty_en_12 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_13 = (dprio0_cnt_odd_div_even_duty_en_13 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_13 = (dprio0_cnt_odd_div_even_duty_en_13 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_14 = (dprio0_cnt_odd_div_even_duty_en_14 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_14 = (dprio0_cnt_odd_div_even_duty_en_14 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_15 = (dprio0_cnt_odd_div_even_duty_en_15 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_15 = (dprio0_cnt_odd_div_even_duty_en_15 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_16 = (dprio0_cnt_odd_div_even_duty_en_16 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_16 = (dprio0_cnt_odd_div_even_duty_en_16 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_17 = (dprio0_cnt_odd_div_even_duty_en_17 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_17 = (dprio0_cnt_odd_div_even_duty_en_17 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;



////////////////////////////////////////////////////////////////////////////////
// pll_bwctrl
////////////////////////////////////////////////////////////////////////////////
localparam PLL_BW_RES_UNUSED5 = 4'b1111 ;
localparam PLL_BW_RES_UNUSED4 = 4'b1110 ;
localparam PLL_BW_RES_UNUSED3 = 4'b1101 ;
localparam PLL_BW_RES_UNUSED2 = 4'b1100 ;
localparam PLL_BW_RES_UNUSED1 = 4'b1011 ;
localparam PLL_BW_RES_0P5K = 4'b1010 ;
localparam PLL_BW_RES_1K = 4'b1001 ;
localparam PLL_BW_RES_2K = 4'b1000 ;
localparam PLL_BW_RES_4K = 4'b0111 ;
localparam PLL_BW_RES_6K = 4'b0110 ;
localparam PLL_BW_RES_8K = 4'b0101 ;
localparam PLL_BW_RES_10K = 4'b0100 ;
localparam PLL_BW_RES_12K = 4'b0011 ;
localparam PLL_BW_RES_14K = 4'b0010 ;
localparam PLL_BW_RES_16K = 4'b0001 ;
localparam PLL_BW_RES_18K = 4'b0000 ;
localparam local_pll_bwctrl_0 = (pll_bwctrl_0 == 18000) ? PLL_BW_RES_18K :
							  (pll_bwctrl_0 == 16000) ? PLL_BW_RES_16K :
							  (pll_bwctrl_0 == 14000) ? PLL_BW_RES_14K :
							  (pll_bwctrl_0 == 12000) ? PLL_BW_RES_12K :
							  (pll_bwctrl_0 == 10000) ? PLL_BW_RES_10K :
							  (pll_bwctrl_0 == 8000) ? PLL_BW_RES_8K :
							  (pll_bwctrl_0 == 6000) ? PLL_BW_RES_6K :
							  (pll_bwctrl_0 == 4000) ? PLL_BW_RES_4K :
							  (pll_bwctrl_0 == 2000) ? PLL_BW_RES_2K :
							  (pll_bwctrl_0 == 1000) ? PLL_BW_RES_1K : 
							  (pll_bwctrl_0 == 500) ? PLL_BW_RES_0P5K : PLL_BW_RES_UNUSED1;
localparam local_pll_bwctrl_1 = (pll_bwctrl_1 == 18000) ? PLL_BW_RES_18K :
							  (pll_bwctrl_1 == 16000) ? PLL_BW_RES_16K :
							  (pll_bwctrl_1 == 14000) ? PLL_BW_RES_14K :
							  (pll_bwctrl_1 == 12000) ? PLL_BW_RES_12K :
							  (pll_bwctrl_1 == 10000) ? PLL_BW_RES_10K :
							  (pll_bwctrl_1 == 8000) ? PLL_BW_RES_8K :
							  (pll_bwctrl_1 == 6000) ? PLL_BW_RES_6K :
							  (pll_bwctrl_1 == 4000) ? PLL_BW_RES_4K :
							  (pll_bwctrl_1 == 2000) ? PLL_BW_RES_2K :
							  (pll_bwctrl_1 == 1000) ? PLL_BW_RES_1K : 
							  (pll_bwctrl_1 == 500) ? PLL_BW_RES_0P5K : PLL_BW_RES_UNUSED1;

////////////////////////////////////////////////////////////////////////////////
// pll_cp_current
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CP_UNUSED3 = 3'b111 ;
localparam PLL_CP_UNUSED2 = 3'b110 ;
localparam PLL_CP_UNUSED1 = 3'b101 ;
localparam PLL_CP_40UA = 3'b100 ;
localparam PLL_CP_30UA = 3'b011 ;
localparam PLL_CP_20UA = 3'b010 ;
localparam PLL_CP_10UA = 3'b001 ;
localparam PLL_CP_5UA = 3'b000 ;
localparam local_pll_cp_current_0 = (pll_cp_current_0 == 5) ? PLL_CP_5UA :
								  (pll_cp_current_0 == 10) ? PLL_CP_10UA :
								  (pll_cp_current_0 == 20) ? PLL_CP_20UA :
								  (pll_cp_current_0 == 30) ? PLL_CP_30UA :
								  (pll_cp_current_0 == 40) ? PLL_CP_40UA : PLL_CP_UNUSED1;
localparam local_pll_cp_current_1 = (pll_cp_current_1 == 5) ? PLL_CP_5UA :
								  (pll_cp_current_1 == 10) ? PLL_CP_10UA :
								  (pll_cp_current_1 == 20) ? PLL_CP_20UA :
								  (pll_cp_current_1 == 30) ? PLL_CP_30UA :
								  (pll_cp_current_1 == 40) ? PLL_CP_40UA : PLL_CP_UNUSED1;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_div
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_DIV_1300 = 1'b1 ;
localparam PLL_VCO_DIV_600 = 1'b0 ;
localparam local_pll_vco_div_0 = (pll_vco_div_0 == 1) ? PLL_VCO_DIV_600 : PLL_VCO_DIV_1300;
localparam local_pll_vco_div_1 = (pll_vco_div_1 == 1) ? PLL_VCO_DIV_600 : PLL_VCO_DIV_1300;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_division_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FRACTIONAL_DIVIDE_VALUE = 32'h00000000 ;
localparam local_pll_fractional_division_0 = pll_fractional_division_0;
localparam local_pll_fractional_division_setting_0 = pll_fractional_division_0;
localparam local_pll_fractional_division_1 = pll_fractional_division_1;
localparam local_pll_fractional_division_setting_1 = pll_fractional_division_1;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_value_ready
////////////////////////////////////////////////////////////////////////////////
localparam PLL_K_READY = 1'b1 ;
localparam PLL_K_NOT_READY = 1'b0 ;
localparam local_pll_fractional_value_ready_0 = (pll_fractional_value_ready_0 == "true") ? PLL_K_READY : PLL_K_NOT_READY;
localparam local_pll_fractional_value_ready_1 = (pll_fractional_value_ready_1 == "true") ? PLL_K_READY : PLL_K_NOT_READY;

////////////////////////////////////////////////////////////////////////////////
// pll_dsm_out_sel
////////////////////////////////////////////////////////////////////////////////
localparam PLL_DSM_3RD_ORDER = 2'b11 ;
localparam PLL_DSM_2ND_ORDER = 2'b10 ;
localparam PLL_DSM_1ST_ORDER = 2'b01 ;
localparam PLL_DSM_DISABLE = 2'b00 ;
localparam local_pll_dsm_out_sel_0 = (pll_dsm_out_sel_0 == "disable") ? PLL_DSM_DISABLE :
								   (pll_dsm_out_sel_0 == "1st_order") ? PLL_DSM_1ST_ORDER :
								   (pll_dsm_out_sel_0 == "2nd_order") ? PLL_DSM_2ND_ORDER : PLL_DSM_3RD_ORDER;
localparam local_pll_dsm_out_sel_1 = (pll_dsm_out_sel_1 == "disable") ? PLL_DSM_DISABLE :
								   (pll_dsm_out_sel_1 == "1st_order") ? PLL_DSM_1ST_ORDER :
								   (pll_dsm_out_sel_1 == "2nd_order") ? PLL_DSM_2ND_ORDER : PLL_DSM_3RD_ORDER;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_carry_out
////////////////////////////////////////////////////////////////////////////////
localparam PLL_COUT_32B = 2'b11 ;
localparam PLL_COUT_24B = 2'b10 ;
localparam PLL_COUT_16B = 2'b01 ;
localparam PLL_COUT_8B = 2'b00 ;
localparam local_pll_fractional_carry_out_0 = (pll_fractional_carry_out_0 == 8) ? PLL_COUT_8B :
											(pll_fractional_carry_out_0 == 16) ? PLL_COUT_16B :
											(pll_fractional_carry_out_0 == 24) ? PLL_COUT_24B : PLL_COUT_32B;
localparam local_pll_fractional_carry_out_1 = (pll_fractional_carry_out_1 == 8) ? PLL_COUT_8B :
											(pll_fractional_carry_out_1 == 16) ? PLL_COUT_16B :
											(pll_fractional_carry_out_1 == 24) ? PLL_COUT_24B : PLL_COUT_32B;

											////////////////////////////////////////////////////////////////////////////////
// pll_dsm_dither
////////////////////////////////////////////////////////////////////////////////
localparam PLL_DITHER_3 = 2'b11 ;
localparam PLL_DITHER_2 = 2'b10 ;
localparam PLL_DITHER_1 = 2'b01 ;
localparam PLL_DITHER_DISABLE = 2'b00 ;
localparam local_pll_dsm_dither_0 = (pll_dsm_dither_0 == "disable") ? PLL_DITHER_DISABLE :
								  (pll_dsm_dither_0 == "pattern1") ? PLL_DITHER_1 :
								  (pll_dsm_dither_0 == "pattern2") ? PLL_DITHER_2 : PLL_DITHER_3;
localparam local_pll_dsm_dither_1 = (pll_dsm_dither_1 == "disable") ? PLL_DITHER_DISABLE :
								  (pll_dsm_dither_1 == "pattern1") ? PLL_DITHER_1 :
								  (pll_dsm_dither_1 == "pattern2") ? PLL_DITHER_2 : PLL_DITHER_3;

////////////////////////////////////////////////////////////////////////////////
// pll_ecn_bypass
////////////////////////////////////////////////////////////////////////////////
localparam PLL_ECN_BYPASS_ENABLE = 1'b1 ;
localparam PLL_ECN_BYPASS_DISABLE = 1'b0 ;
localparam local_pll_ecn_bypass_0 = (pll_ecn_bypass_0 == "false") ? PLL_ECN_BYPASS_DISABLE : PLL_ECN_BYPASS_ENABLE;
localparam local_pll_ecn_bypass_1 = (pll_ecn_bypass_1 == "false") ? PLL_ECN_BYPASS_DISABLE : PLL_ECN_BYPASS_ENABLE;
wire [1:0] fbclk;wire [number_of_counters-1:0] cascade_out_wire;
	arriavgz_ffpll_reconfig #(
		.P_XCLKIN_MUX_SO_0__PLL_CLKIN_0_SRC(local_pll_clkin_0_src_0),
		.P_XCLKIN_MUX_SO_0__PLL_CLKIN_1_SRC(local_pll_clkin_1_src_0),
        .P_XCLKIN_MUX_SO_0__PLL_CLK_SW_DLY(local_pll_clk_sw_dly_0), 
        .P_XCLKIN_MUX_SO_0__PLL_CLK_SW_DLY_SETTING(local_pll_clk_sw_dly_0), 	
        .P_XCLKIN_MUX_SO_0__PLL_MANU_CLK_SW_EN(local_pll_manu_clk_sw_en_0),
        .P_XCLKIN_MUX_SO_0__PLL_AUTO_CLK_SW_EN(local_pll_auto_clk_sw_en_0),
        .P_XCLKIN_MUX_SO_0__PLL_CLK_LOSS_SW_EN(local_pll_clk_loss_sw_en_0),
		.P_XCLKIN_MUX_SO_1__PLL_CLKIN_0_SRC(local_pll_clkin_0_src_1),
		.P_XCLKIN_MUX_SO_1__PLL_CLKIN_1_SRC(local_pll_clkin_1_src_1),
        .P_XCLKIN_MUX_SO_1__PLL_CLK_SW_DLY(local_pll_clk_sw_dly_1), 
        .P_XCLKIN_MUX_SO_1__PLL_CLK_SW_DLY_SETTING(local_pll_clk_sw_dly_1), 	
        .P_XCLKIN_MUX_SO_1__PLL_MANU_CLK_SW_EN(local_pll_manu_clk_sw_en_1),
        .P_XCLKIN_MUX_SO_1__PLL_AUTO_CLK_SW_EN(local_pll_auto_clk_sw_en_1),
        .P_XCLKIN_MUX_SO_1__PLL_CLK_LOSS_SW_EN(local_pll_clk_loss_sw_en_1),
    		
        .P_XFPLL_0__PLL_VCO_PH7_EN(local_pll_vco_ph7_en_0),
		.P_XFPLL_0__PLL_VCO_PH6_EN(local_pll_vco_ph6_en_0),
		.P_XFPLL_0__PLL_VCO_PH5_EN(local_pll_vco_ph5_en_0),
		.P_XFPLL_0__PLL_VCO_PH4_EN(local_pll_vco_ph4_en_0),
		.P_XFPLL_0__PLL_VCO_PH3_EN(local_pll_vco_ph3_en_0),
		.P_XFPLL_0__PLL_VCO_PH2_EN(local_pll_vco_ph2_en_0),
		.P_XFPLL_0__PLL_VCO_PH1_EN(local_pll_vco_ph1_en_0),
		.P_XFPLL_0__PLL_VCO_PH0_EN(local_pll_vco_ph0_en_0),
		.P_XFPLL_0__PLL_ENABLE(local_pll_enable_0),
		.P_XFPLL_0__PLL_CTRL_OVERRIDE_SETTING(local_pll_ctrl_override_setting_0),
		.P_XFPLL_0__PLL_FBCLK_MUX_2(local_pll_fbclk_mux_2_0),
		.P_XFPLL_0__PLL_FBCLK_MUX_1(local_pll_fbclk_mux_1_0),
		.P_XFPLL_0__PLL_N_CNT_BYPASS_EN(local_pll_n_cnt_bypass_en_0),
		.P_XFPLL_0__PLL_N_CNT_LO_DIV_SETTING(local_pll_n_cnt_lo_div_setting_0),
		.P_XFPLL_0__PLL_N_CNT_LO_DIV(local_pll_n_cnt_lo_div_0),
		.P_XFPLL_0__PLL_N_CNT_HI_DIV_SETTING(local_pll_n_cnt_hi_div_setting_0),
		.P_XFPLL_0__PLL_N_CNT_HI_DIV(local_pll_n_cnt_hi_div_0),
		.P_XFPLL_0__PLL_N_CNT_ODD_DIV_DUTY_EN(local_pll_n_cnt_odd_div_duty_en_0),
		.P_XFPLL_0__PLL_TCLK_SEL(local_pll_tclk_sel_0),
		.P_XFPLL_0__PLL_M_CNT_ODD_DIV_DUTY_EN(local_pll_m_cnt_odd_div_duty_en_0),
		.P_XFPLL_0__PLL_M_CNT_BYPASS_EN(local_pll_m_cnt_bypass_en_0),
		.P_XFPLL_0__PLL_M_CNT_IN_SRC(local_pll_m_cnt_in_src_0),
		.P_XFPLL_0__PLL_M_CNT_LO_DIV_SETTING(local_pll_m_cnt_lo_div_setting_0),
		.P_XFPLL_0__PLL_M_CNT_LO_DIV(local_pll_m_cnt_lo_div_0),
		.P_XFPLL_0__PLL_M_CNT_HI_DIV_SETTING(local_pll_m_cnt_hi_div_setting_0),
		.P_XFPLL_0__PLL_M_CNT_HI_DIV(local_pll_m_cnt_hi_div_0),
		.P_XFPLL_0__PLL_M_CNT_PRST(local_pll_m_cnt_prst_0),
		.P_XFPLL_0__PLL_M_CNT_PRST_SETTING(local_pll_m_cnt_prst_setting_0),
		.P_XFPLL_0__PLL_UNLOCK_FLTR_CFG_SETTING(local_pll_unlock_fltr_cfg_setting_0),
		.P_XFPLL_0__PLL_UNLOCK_FLTR_CFG(local_pll_unlock_fltr_cfg_0),
		.P_XFPLL_0__PLL_LOCK_FLTR_CFG_SETTING(local_pll_lock_fltr_cfg_setting_0),
		.P_XFPLL_0__PLL_LOCK_FLTR_CFG(local_pll_lock_fltr_cfg_0),
		.P_XFPLL_0__PLL_DSM_OUT_SEL(local_pll_dsm_out_sel_0),
		.P_XFPLL_0__PLL_FRACTIONAL_DIVISION_SETTING(local_pll_fractional_division_setting_0),
		.P_XFPLL_0__PLL_FRACTIONAL_DIVISION(local_pll_fractional_division_0),
		.P_XFPLL_0__PLL_FRACTIONAL_VALUE_READY(local_pll_fractional_value_ready_0),
		.P_XFPLL_0__PLL_FRACTIONAL_CARRY_OUT(local_pll_fractional_carry_out_0),
		.P_XFPLL_0__PLL_ECN_BYPASS(local_pll_ecn_bypass_0),
		.P_XFPLL_0__PLL_DSM_DITHER(local_pll_dsm_dither_0),
        .P_XFPLL_0__PLL_VCO_DIV(1'b1),
        .P_XFPLL_0__PLL_CP_CURRENT(local_pll_cp_current_0),
        .P_XFPLL_0__PLL_BWCTRL(local_pll_bwctrl_0),
		.P_XFPLL_1__PLL_VCO_PH7_EN(local_pll_vco_ph7_en_1),
		.P_XFPLL_1__PLL_VCO_PH6_EN(local_pll_vco_ph6_en_1),
		.P_XFPLL_1__PLL_VCO_PH5_EN(local_pll_vco_ph5_en_1),
		.P_XFPLL_1__PLL_VCO_PH4_EN(local_pll_vco_ph4_en_1),
		.P_XFPLL_1__PLL_VCO_PH3_EN(local_pll_vco_ph3_en_1),
		.P_XFPLL_1__PLL_VCO_PH2_EN(local_pll_vco_ph2_en_1),
		.P_XFPLL_1__PLL_VCO_PH1_EN(local_pll_vco_ph1_en_1),
		.P_XFPLL_1__PLL_VCO_PH0_EN(local_pll_vco_ph0_en_1),
		.P_XFPLL_1__PLL_ENABLE(local_pll_enable_1),
		.P_XFPLL_1__PLL_CTRL_OVERRIDE_SETTING(local_pll_ctrl_override_setting_1),
		.P_XFPLL_1__PLL_FBCLK_MUX_2(local_pll_fbclk_mux_2_1),
		.P_XFPLL_1__PLL_FBCLK_MUX_1(local_pll_fbclk_mux_1_1),
		.P_XFPLL_1__PLL_N_CNT_BYPASS_EN(local_pll_n_cnt_bypass_en_1),
		.P_XFPLL_1__PLL_N_CNT_LO_DIV_SETTING(local_pll_n_cnt_lo_div_setting_1),
		.P_XFPLL_1__PLL_N_CNT_LO_DIV(local_pll_n_cnt_lo_div_1),
		.P_XFPLL_1__PLL_N_CNT_HI_DIV_SETTING(local_pll_n_cnt_hi_div_setting_1),
		.P_XFPLL_1__PLL_N_CNT_HI_DIV(local_pll_n_cnt_hi_div_1),
		.P_XFPLL_1__PLL_N_CNT_ODD_DIV_DUTY_EN(local_pll_n_cnt_odd_div_duty_en_1),
		.P_XFPLL_1__PLL_TCLK_SEL(local_pll_tclk_sel_1),
		.P_XFPLL_1__PLL_M_CNT_ODD_DIV_DUTY_EN(local_pll_m_cnt_odd_div_duty_en_1),
		.P_XFPLL_1__PLL_M_CNT_BYPASS_EN(local_pll_m_cnt_bypass_en_1),
		.P_XFPLL_1__PLL_M_CNT_IN_SRC(local_pll_m_cnt_in_src_1),
		.P_XFPLL_1__PLL_M_CNT_LO_DIV_SETTING(local_pll_m_cnt_lo_div_setting_1),
		.P_XFPLL_1__PLL_M_CNT_LO_DIV(local_pll_m_cnt_lo_div_1),
		.P_XFPLL_1__PLL_M_CNT_HI_DIV_SETTING(local_pll_m_cnt_hi_div_setting_1),
		.P_XFPLL_1__PLL_M_CNT_HI_DIV(local_pll_m_cnt_hi_div_1),
		.P_XFPLL_1__PLL_M_CNT_PRST(local_pll_m_cnt_prst_1),
		.P_XFPLL_1__PLL_M_CNT_PRST_SETTING(local_pll_m_cnt_prst_setting_1),
		.P_XFPLL_1__PLL_UNLOCK_FLTR_CFG_SETTING(local_pll_unlock_fltr_cfg_setting_1),
		.P_XFPLL_1__PLL_UNLOCK_FLTR_CFG(local_pll_unlock_fltr_cfg_1),
		.P_XFPLL_1__PLL_LOCK_FLTR_CFG_SETTING(local_pll_lock_fltr_cfg_setting_1),
		.P_XFPLL_1__PLL_LOCK_FLTR_CFG(local_pll_lock_fltr_cfg_1),
		.P_XFPLL_1__PLL_DSM_OUT_SEL(local_pll_dsm_out_sel_1),
		.P_XFPLL_1__PLL_FRACTIONAL_DIVISION_SETTING(local_pll_fractional_division_setting_1),
		.P_XFPLL_1__PLL_FRACTIONAL_DIVISION(local_pll_fractional_division_1),
		.P_XFPLL_1__PLL_FRACTIONAL_VALUE_READY(local_pll_fractional_value_ready_1),
		.P_XFPLL_1__PLL_FRACTIONAL_CARRY_OUT(local_pll_fractional_carry_out_1),
		.P_XFPLL_1__PLL_DSM_DITHER(local_pll_dsm_dither_1),
		.P_XFPLL_1__PLL_ECN_BYPASS(local_pll_ecn_bypass_1),
        .P_XFPLL_1__PLL_VCO_DIV(1'b1),
        .P_XFPLL_1__PLL_CP_CURRENT(local_pll_cp_current_1),
        .P_XFPLL_1__PLL_BWCTRL(local_pll_bwctrl_1),

        .P_X18CCNTS__XCCNT_0__C_CNT_IN_SRC(local_c_cnt_in_src_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PRST(local_c_cnt_prst_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PRST_USER(local_c_cnt_prst_user_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_0),
		.P_X18CCNTS__XCCNT_1__C_CNT_IN_SRC(local_c_cnt_in_src_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PRST(local_c_cnt_prst_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PRST_USER(local_c_cnt_prst_user_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_1),
		.P_X18CCNTS__XCCNT_2__C_CNT_IN_SRC(local_c_cnt_in_src_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PRST(local_c_cnt_prst_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PRST_USER(local_c_cnt_prst_user_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_2),
		.P_X18CCNTS__XCCNT_3__C_CNT_IN_SRC(local_c_cnt_in_src_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PRST(local_c_cnt_prst_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PRST_USER(local_c_cnt_prst_user_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_3),
		.P_X18CCNTS__XCCNT_4__C_CNT_IN_SRC(local_c_cnt_in_src_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PRST(local_c_cnt_prst_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PRST_USER(local_c_cnt_prst_user_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_4),
		.P_X18CCNTS__XCCNT_5__C_CNT_IN_SRC(local_c_cnt_in_src_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PRST(local_c_cnt_prst_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PRST_USER(local_c_cnt_prst_user_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_5),
		.P_X18CCNTS__XCCNT_6__C_CNT_IN_SRC(local_c_cnt_in_src_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PRST(local_c_cnt_prst_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PRST_USER(local_c_cnt_prst_user_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_6),
		.P_X18CCNTS__XCCNT_7__C_CNT_IN_SRC(local_c_cnt_in_src_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PRST(local_c_cnt_prst_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PRST_USER(local_c_cnt_prst_user_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_7),
		.P_X18CCNTS__XCCNT_8__C_CNT_IN_SRC(local_c_cnt_in_src_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PRST(local_c_cnt_prst_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PRST_USER(local_c_cnt_prst_user_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_8),
		.P_X18CCNTS__XCCNT_9__C_CNT_IN_SRC(local_c_cnt_in_src_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PRST(local_c_cnt_prst_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PRST_USER(local_c_cnt_prst_user_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_9),
		.P_X18CCNTS__XCCNT_9__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_9),
		.P_X18CCNTS__XCCNT_9__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_9),
		.P_X18CCNTS__XCCNT_10__C_CNT_IN_SRC(local_c_cnt_in_src_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PRST(local_c_cnt_prst_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PRST_USER(local_c_cnt_prst_user_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_10),
		.P_X18CCNTS__XCCNT_10__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_10),
		.P_X18CCNTS__XCCNT_10__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_10),
		.P_X18CCNTS__XCCNT_11__C_CNT_IN_SRC(local_c_cnt_in_src_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PRST(local_c_cnt_prst_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PRST_USER(local_c_cnt_prst_user_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_11),
		.P_X18CCNTS__XCCNT_11__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_11),
		.P_X18CCNTS__XCCNT_11__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_11),
		.P_X18CCNTS__XCCNT_12__C_CNT_IN_SRC(local_c_cnt_in_src_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PRST(local_c_cnt_prst_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PRST_USER(local_c_cnt_prst_user_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_12),
		.P_X18CCNTS__XCCNT_12__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_12),
		.P_X18CCNTS__XCCNT_12__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_12),
		.P_X18CCNTS__XCCNT_13__C_CNT_IN_SRC(local_c_cnt_in_src_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PRST(local_c_cnt_prst_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PRST_USER(local_c_cnt_prst_user_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_13),
		.P_X18CCNTS__XCCNT_13__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_13),
		.P_X18CCNTS__XCCNT_13__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_13),
		.P_X18CCNTS__XCCNT_14__C_CNT_IN_SRC(local_c_cnt_in_src_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PRST(local_c_cnt_prst_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PRST_USER(local_c_cnt_prst_user_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_14),
		.P_X18CCNTS__XCCNT_14__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_14),
		.P_X18CCNTS__XCCNT_14__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_14),
		.P_X18CCNTS__XCCNT_15__C_CNT_IN_SRC(local_c_cnt_in_src_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PRST(local_c_cnt_prst_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PRST_USER(local_c_cnt_prst_user_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_15),
		.P_X18CCNTS__XCCNT_15__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_15),
		.P_X18CCNTS__XCCNT_15__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_15),
		.P_X18CCNTS__XCCNT_16__C_CNT_IN_SRC(local_c_cnt_in_src_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PRST(local_c_cnt_prst_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PRST_USER(local_c_cnt_prst_user_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_16),
		.P_X18CCNTS__XCCNT_16__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_16),
		.P_X18CCNTS__XCCNT_16__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_16),
		.P_X18CCNTS__XCCNT_17__C_CNT_IN_SRC(local_c_cnt_in_src_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PRST(local_c_cnt_prst_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PRST_USER(local_c_cnt_prst_user_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_17),
		.P_X18CCNTS__XCCNT_17__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_17),
		.P_X18CCNTS__XCCNT_17__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_17)		
	) arriavgz_ffpll_inst (
	  // arriavgz_pll_dpa_output pins
	  .dpaclk0_i(phout_0),
	  .dpaclk1_i(phout_1),
	  
	  // arriavgz_pll_refclk_select pins
	  .pll_cas_in0(adjpllin[0]),
	  .coreclk0(coreclkin[0]),	  	  .coreclk1(cclk[0]),
	  .extswitch0(extswitch[0]),
	  .iqtxrxclk_fpll0(iqtxrxclkin[0]),
	  .ref_iqclk_fpll0(plliqclkin[0]),
	  .rx_iqclk_fpll0(rxiqclkin[0]),
	  .clkin(clkin),
	  .refclk_fpll0(refiqclk_0[0]),
	  .clk0_bad0(clk0bad[0]),
	  .clk1_bad0(clk1bad[0]),
	  .clksel0(pllclksel[0]),

	  // arriavgz_pll_reconfig pins
	  .atpgmode0(atpgmode[0]),
	  .dprio0_clk(clk[0]),
	  .ffpll_csr_test0(fpllcsrtest[0]),
	  .iocsr_clkin(iocsrclkin[0]),
	  .iocsr_datain(iocsrdatain[0]),
	  .dprio0_mdio_dis(mdiodis[0]),
	  .phase_en0(phaseen[0]),
	  .dprio0_read(read[0]),
	  .dprio0_rst_n(rstn[0]),
	  .scanen0(scanen[0]),
	  .dprio0_ser_shift_load(sershiftload[0]),
	  .up_dn0(updn[0]),
	  .dprio0_write(write[0]),
	  .dprio0_reg_addr(addr_0),
	  .dprio1_reg_addr(addr_1),
	  .dprio0_byte_en(byteen_0),
	  .dprio1_byte_en(byteen_1),
	  .cnt_sel0(cntsel_0),
	  .cnt_sel1(cntsel_1),
	  .dprio0_writedata(din_0),
	  .dprio1_writedata(din_1),
	  .dprio0_block_select(blockselect[0]),
	  .iocsr_dataout(iocsrdataout[0]),
	  .phase_done0(phasedone[0]),
	  .dprio0_readdata(dout_0),
	  .dprio1_readdata(dout_1),
	  
	  // arriavgz_fractional_pll pins
          .pllmout0(fbclk[0]),
          .fbclk_in0(fbclk[0]),
	  .fbclk_fpll0(fbclkfpll[0]),
	  .fblvds_in0(lvdfbin[0]),
	  .nreset0(nresync[0]),
	  .pfden0(pfden[0]),
	  .zdb_in0(zdb[0]),
	  .fblvds_out0(fblvdsout[0]),
	  .lock0(lock[0]),
	  
	  // arriavgz_pll_extclk_output pins
	  .clken(clken),
	  .extclk(extclk),
	  
	  // arriavgz_pll_dll_output pins
	  .plldout0(clkout[0]),
	  
	  // arriavgz_pll_lvds_output pins
	  .loaden0({loaden[1], loaden[0]}),
	  .loaden1({loaden[3], loaden[2]}),
	  .lvds_clk0({lvdsclk[1], lvdsclk[0]}),
	  .lvds_clk1({lvdsclk[1], lvdsclk[0]}),
	  
	  // arriavgz_pll_output_counter pins
	  .divclk(divclk),
	  .pll_cas_out1(),
	  // others
	  .ioplniotri(nresync[0]),
	  .nfrzdrv(nresync[0]),
	  .pllbias(nresync[0])
	);	// assign cascade_out to divclk	// This is used as a workaround in RTL simulation as cascade_out needs to be output counter location dependent	assign cascade_out = divclk;

endmodule
`timescale 1 ps/1 ps

module altera_cyclonev_pll
#(	
	// Parameter declarations and default value assignments
	parameter number_of_counters = 9,	
	parameter number_of_fplls = 1,
	parameter number_of_extclks = 2,
	parameter number_of_dlls = 1,
	parameter number_of_lvds = 2,

	// cyclonev_pll_refclk_select parameters -- FF_PLL 0
	parameter pll_auto_clk_sw_en_0 = "false",
	parameter pll_clk_loss_edge_0 = "both_edges",
	parameter pll_clk_loss_sw_en_0 = "false",
	parameter pll_clk_sw_dly_0 = 0,
	parameter pll_clkin_0_src_0 = "clk_0",
	parameter pll_clkin_1_src_0 = "clk_0",
	parameter pll_manu_clk_sw_en_0 = "false",
	parameter pll_sw_refclk_src_0 = "clk_0",
	
	// cyclonev_pll_refclk_select parameters -- FF_PLL 1
	parameter pll_auto_clk_sw_en_1 = "false",
	parameter pll_clk_loss_edge_1 = "both_edges",
	parameter pll_clk_loss_sw_en_1 = "false",
	parameter pll_clk_sw_dly_1 = 0,
	parameter pll_clkin_0_src_1 = "clk_1",
	parameter pll_clkin_1_src_1 = "clk_1",
	parameter pll_manu_clk_sw_en_1 = "false",
	parameter pll_sw_refclk_src_1 = "clk_1",
	
	// cyclonev_fractional_pll parameters -- FF_PLL 0
	parameter pll_output_clock_frequency_0 = "700.0 MHz",
	parameter reference_clock_frequency_0 = "700.0 MHz",
	parameter mimic_fbclk_type_0 = "gclk",
	parameter dsm_accumulator_reset_value_0 = 0,
	parameter forcelock_0 = "false",
	parameter nreset_invert_0 = "false",
	parameter pll_atb_0 = 0,
	parameter pll_bwctrl_0 = 1000,
	parameter pll_cmp_buf_dly_0 = "0 ps",
	parameter pll_cp_comp_0 = "true",
	parameter pll_cp_current_0 = 20,
	parameter pll_ctrl_override_setting_0 = "true",
	parameter pll_dsm_dither_0 = "disable",
	parameter pll_dsm_out_sel_0 = "disable",
	parameter pll_dsm_reset_0 = "false",
	parameter pll_ecn_bypass_0 = "false",
	parameter pll_ecn_test_en_0 = "false",
	parameter pll_enable_0 = "true",
	parameter pll_fbclk_mux_1_0 = "fb",
	parameter pll_fbclk_mux_2_0 = "m_cnt",
	parameter pll_fractional_carry_out_0 = 24,
	parameter pll_fractional_division_0 = 1,
	parameter pll_fractional_value_ready_0 = "true",
	parameter pll_lf_testen_0 = "false",
	parameter pll_lock_fltr_cfg_0 = 25,
	parameter pll_lock_fltr_test_0 = "false",
	parameter pll_m_cnt_bypass_en_0 = "false",
	parameter pll_m_cnt_coarse_dly_0 = "0 ps",
	parameter pll_m_cnt_fine_dly_0 = "0 ps",
	parameter pll_m_cnt_hi_div_0 = 3,
	parameter pll_m_cnt_in_src_0 = "ph_mux_clk",
	parameter pll_m_cnt_lo_div_0 = 3,
	parameter pll_m_cnt_odd_div_duty_en_0 = "false",
	parameter pll_m_cnt_ph_mux_prst_0 = 0,
	parameter pll_m_cnt_prst_0 = 256,
	parameter pll_n_cnt_bypass_en_0 = "true",
	parameter pll_n_cnt_coarse_dly_0 = "0 ps",
	parameter pll_n_cnt_fine_dly_0 = "0 ps",
	parameter pll_n_cnt_hi_div_0 = 1,
	parameter pll_n_cnt_lo_div_0 = 1,
	parameter pll_n_cnt_odd_div_duty_en_0 = "false",
	parameter pll_ref_buf_dly_0 = "0 ps",
	parameter pll_reg_boost_0 = 0,
	parameter pll_regulator_bypass_0 = "false",
	parameter pll_ripplecap_ctrl_0 = 0,
	parameter pll_slf_rst_0 = "false",
	parameter pll_tclk_mux_en_0 = "false",
	parameter pll_tclk_sel_0 = "n_src",
	parameter pll_test_enable_0 = "false",
	parameter pll_testdn_enable_0 = "false",
	parameter pll_testup_enable_0 = "false",
	parameter pll_unlock_fltr_cfg_0 = 1,
	parameter pll_vco_div_0 = 0,
	parameter pll_vco_ph0_en_0 = "true",
	parameter pll_vco_ph1_en_0 = "true",
	parameter pll_vco_ph2_en_0 = "true",
	parameter pll_vco_ph3_en_0 = "true",
	parameter pll_vco_ph4_en_0 = "true",
	parameter pll_vco_ph5_en_0 = "true",
	parameter pll_vco_ph6_en_0 = "true",
	parameter pll_vco_ph7_en_0 = "true",
	parameter pll_vctrl_test_voltage_0 = 750,
	parameter vccd0g_atb_0 = "disable",
	parameter vccd0g_output_0 = 0,
	parameter vccd1g_atb_0 = "disable",
	parameter vccd1g_output_0 = 0,
	parameter vccm1g_tap_0 = 2,
	parameter vccr_pd_0 = "false",
	parameter vcodiv_override_0 = "false",
    parameter sim_use_fast_model_0 = "false",
    
	// cyclonev_pll_output_counter parameters -- counter 0
	parameter output_clock_frequency_0 = "100.0 MHz",
	parameter enable_output_counter_0 = "true",
	parameter phase_shift_0 = "0 ps",
	parameter duty_cycle_0 = 50,
	parameter c_cnt_coarse_dly_0 = "0 ps",
	parameter c_cnt_fine_dly_0 = "0 ps",
	parameter c_cnt_in_src_0 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_0 = 0,
	parameter c_cnt_prst_0 = 1,
	parameter cnt_fpll_src_0 = "fpll_0",
	parameter dprio0_cnt_bypass_en_0 = "true",
	parameter dprio0_cnt_hi_div_0 = 3,
	parameter dprio0_cnt_lo_div_0 = 3,
	parameter dprio0_cnt_odd_div_even_duty_en_0 = "false",
	parameter dprio1_cnt_bypass_en_0 = dprio0_cnt_bypass_en_0,
	parameter dprio1_cnt_hi_div_0 = dprio0_cnt_hi_div_0,
	parameter dprio1_cnt_lo_div_0 = dprio0_cnt_lo_div_0,
	parameter dprio1_cnt_odd_div_even_duty_en_0 = dprio0_cnt_odd_div_even_duty_en_0,
	
	parameter output_clock_frequency_1 = "0 ps",
	parameter enable_output_counter_1 = "true",
	parameter phase_shift_1 = "0 ps",
	parameter duty_cycle_1 = 50,
	parameter c_cnt_coarse_dly_1 = "0 ps",
	parameter c_cnt_fine_dly_1 = "0 ps",
	parameter c_cnt_in_src_1 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_1 = 0,
	parameter c_cnt_prst_1 = 1,
	parameter cnt_fpll_src_1 = "fpll_0",
	parameter dprio0_cnt_bypass_en_1 = "true",
	parameter dprio0_cnt_hi_div_1 = 2,
	parameter dprio0_cnt_lo_div_1 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_1 = "true",
	parameter dprio1_cnt_bypass_en_1 = dprio0_cnt_bypass_en_1,
	parameter dprio1_cnt_hi_div_1 = dprio0_cnt_hi_div_1,
	parameter dprio1_cnt_lo_div_1 = dprio0_cnt_lo_div_1,
	parameter dprio1_cnt_odd_div_even_duty_en_1 = dprio0_cnt_odd_div_even_duty_en_1,
	
	parameter output_clock_frequency_2 = "0 ps",
	parameter enable_output_counter_2 = "true",
	parameter phase_shift_2 = "0 ps",
	parameter duty_cycle_2 = 50,
	parameter c_cnt_coarse_dly_2 = "0 ps",
	parameter c_cnt_fine_dly_2 = "0 ps",
	parameter c_cnt_in_src_2 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_2 = 0,
	parameter c_cnt_prst_2 = 1,
	parameter cnt_fpll_src_2 = "fpll_0",
	parameter dprio0_cnt_bypass_en_2 = "true",
	parameter dprio0_cnt_hi_div_2 = 1,
	parameter dprio0_cnt_lo_div_2 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_2 = "false",
	parameter dprio1_cnt_bypass_en_2 = dprio0_cnt_bypass_en_2,
	parameter dprio1_cnt_hi_div_2 = dprio0_cnt_hi_div_2,
	parameter dprio1_cnt_lo_div_2 = dprio0_cnt_lo_div_2,
	parameter dprio1_cnt_odd_div_even_duty_en_2 = dprio0_cnt_odd_div_even_duty_en_2,
	
	parameter output_clock_frequency_3 = "0 ps",
	parameter enable_output_counter_3 = "true",
	parameter phase_shift_3 = "0 ps",
	parameter duty_cycle_3 = 50,
	parameter c_cnt_coarse_dly_3 = "0 ps",
	parameter c_cnt_fine_dly_3 = "0 ps",
	parameter c_cnt_in_src_3 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_3 = 0,
	parameter c_cnt_prst_3 = 1,
	parameter cnt_fpll_src_3 = "fpll_0",
	parameter dprio0_cnt_bypass_en_3 = "false",
	parameter dprio0_cnt_hi_div_3 = 1,
	parameter dprio0_cnt_lo_div_3 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_3 = "false",
	parameter dprio1_cnt_bypass_en_3 = dprio0_cnt_bypass_en_3,
	parameter dprio1_cnt_hi_div_3 = dprio0_cnt_hi_div_3,
	parameter dprio1_cnt_lo_div_3 = dprio0_cnt_lo_div_3,
	parameter dprio1_cnt_odd_div_even_duty_en_3 = dprio0_cnt_odd_div_even_duty_en_3,
	
	parameter output_clock_frequency_4 = "0 ps",
	parameter enable_output_counter_4 = "true",
	parameter phase_shift_4 = "0 ps",
	parameter duty_cycle_4 = 50,
	parameter c_cnt_coarse_dly_4 = "0 ps",
	parameter c_cnt_fine_dly_4 = "0 ps",
	parameter c_cnt_in_src_4 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_4 = 0,
	parameter c_cnt_prst_4 = 1,
	parameter cnt_fpll_src_4 = "fpll_0",
	parameter dprio0_cnt_bypass_en_4 = "false",
	parameter dprio0_cnt_hi_div_4 = 1,
	parameter dprio0_cnt_lo_div_4 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_4 = "false",
	parameter dprio1_cnt_bypass_en_4 = dprio0_cnt_bypass_en_4,
	parameter dprio1_cnt_hi_div_4 = dprio0_cnt_hi_div_4,
	parameter dprio1_cnt_lo_div_4 = dprio0_cnt_lo_div_4,
	parameter dprio1_cnt_odd_div_even_duty_en_4 = dprio0_cnt_odd_div_even_duty_en_4,
	
	parameter output_clock_frequency_5 = "0 ps",
	parameter enable_output_counter_5 = "true",
	parameter phase_shift_5 = "0 ps",
	parameter duty_cycle_5 = 50,
	parameter c_cnt_coarse_dly_5 = "0 ps",
	parameter c_cnt_fine_dly_5 = "0 ps",
	parameter c_cnt_in_src_5 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_5 = 0,
	parameter c_cnt_prst_5 = 1,
	parameter cnt_fpll_src_5 = "fpll_0",
	parameter dprio0_cnt_bypass_en_5 = "false",
	parameter dprio0_cnt_hi_div_5 = 1,
	parameter dprio0_cnt_lo_div_5 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_5 = "false",
	parameter dprio1_cnt_bypass_en_5 = dprio0_cnt_bypass_en_5,
	parameter dprio1_cnt_hi_div_5 = dprio0_cnt_hi_div_5,
	parameter dprio1_cnt_lo_div_5 = dprio0_cnt_lo_div_5,
	parameter dprio1_cnt_odd_div_even_duty_en_5 = dprio0_cnt_odd_div_even_duty_en_5,
	
	parameter output_clock_frequency_6 = "0 ps",
	parameter enable_output_counter_6 = "true",
	parameter phase_shift_6 = "0 ps",
	parameter duty_cycle_6 = 50,
	parameter c_cnt_coarse_dly_6 = "0 ps",
	parameter c_cnt_fine_dly_6 = "0 ps",
	parameter c_cnt_in_src_6 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_6 = 0,
	parameter c_cnt_prst_6 = 1,
	parameter cnt_fpll_src_6 = "fpll_0",
	parameter dprio0_cnt_bypass_en_6 = "false",
	parameter dprio0_cnt_hi_div_6 = 1,
	parameter dprio0_cnt_lo_div_6 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_6 = "false",
	parameter dprio1_cnt_bypass_en_6 = dprio0_cnt_bypass_en_6,
	parameter dprio1_cnt_hi_div_6 = dprio0_cnt_hi_div_6,
	parameter dprio1_cnt_lo_div_6 = dprio0_cnt_lo_div_6,
	parameter dprio1_cnt_odd_div_even_duty_en_6 = dprio0_cnt_odd_div_even_duty_en_6,
	
	parameter output_clock_frequency_7 = "0 ps",
	parameter enable_output_counter_7 = "true",
	parameter phase_shift_7 = "0 ps",
	parameter duty_cycle_7 = 50,
	parameter c_cnt_coarse_dly_7 = "0 ps",
	parameter c_cnt_fine_dly_7 = "0 ps",
	parameter c_cnt_in_src_7 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_7 = 0,
	parameter c_cnt_prst_7 = 1,
	parameter cnt_fpll_src_7 = "fpll_0",
	parameter dprio0_cnt_bypass_en_7 = "false",
	parameter dprio0_cnt_hi_div_7 = 1,
	parameter dprio0_cnt_lo_div_7 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_7 = "false",
	parameter dprio1_cnt_bypass_en_7 = dprio0_cnt_bypass_en_7,
	parameter dprio1_cnt_hi_div_7 = dprio0_cnt_hi_div_7,
	parameter dprio1_cnt_lo_div_7 = dprio0_cnt_lo_div_7,
	parameter dprio1_cnt_odd_div_even_duty_en_7 = dprio0_cnt_odd_div_even_duty_en_7,
	
	parameter output_clock_frequency_8 = "0 ps",
	parameter enable_output_counter_8 = "true",
	parameter phase_shift_8 = "0 ps",
	parameter duty_cycle_8 = 50,
	parameter c_cnt_coarse_dly_8 = "0 ps",
	parameter c_cnt_fine_dly_8 = "0 ps",
	parameter c_cnt_in_src_8 = "ph_mux_clk",
	parameter c_cnt_ph_mux_prst_8 = 0,
	parameter c_cnt_prst_8 = 1,
	parameter cnt_fpll_src_8 = "fpll_0",
	parameter dprio0_cnt_bypass_en_8 = "false",
	parameter dprio0_cnt_hi_div_8 = 1,
	parameter dprio0_cnt_lo_div_8 = 1,
	parameter dprio0_cnt_odd_div_even_duty_en_8 = "false",
	parameter dprio1_cnt_bypass_en_8 = dprio0_cnt_bypass_en_8,
	parameter dprio1_cnt_hi_div_8 = dprio0_cnt_hi_div_8,
	parameter dprio1_cnt_lo_div_8 = dprio0_cnt_lo_div_8,
	parameter dprio1_cnt_odd_div_even_duty_en_8 = dprio0_cnt_odd_div_even_duty_en_8,
	

	// cyclonev_pll_dpa_output parameters -- dpa_output 0
	parameter dpa_output_clock_frequency_0 = "0 ps",
	parameter pll_vcoph_div_0 = 1,

	
	// cyclonev_pll_extclk_output parameters -- extclk 0
	parameter enable_extclk_output_0 = "false",
	parameter pll_extclk_cnt_src_0 = "vss",
	parameter pll_extclk_enable_0 = "true",
	parameter pll_extclk_invert_0 = "false",
	
	parameter enable_extclk_output_1 = "false",
	parameter pll_extclk_cnt_src_1 = "vss",
	parameter pll_extclk_enable_1 = "true",
	parameter pll_extclk_invert_1 = "false",
	
	
	// cyclonev_pll_dll_output parameters -- dll_output 0
	parameter enable_dll_output_0 = "false",
	parameter pll_dll_src_value_0 = "vss",

	// cyclonev_pll_lvds_output parameters -- lvds_output 0
	parameter enable_lvds_output_0 = "false",
	parameter pll_loaden_coarse_dly_0 = "0 ps",
	parameter pll_loaden_enable_disable_0 = "true",
	parameter pll_loaden_fine_dly_0 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_0 = "0 ps",
	parameter pll_lvdsclk_enable_disable_0 = "true",
	parameter pll_lvdsclk_fine_dly_0 = "0 ps",

	parameter enable_lvds_output_1 = "false",
	parameter pll_loaden_coarse_dly_1 = "0 ps",
	parameter pll_loaden_enable_disable_1 = "true",
	parameter pll_loaden_fine_dly_1 = "0 ps",
	parameter pll_lvdsclk_coarse_dly_1 = "0 ps",
	parameter pll_lvdsclk_enable_disable_1 = "true",
	parameter pll_lvdsclk_fine_dly_1 = "0 ps"

)
(
	// cyclonev_pll_dpa_output pins
	output [7:0] phout_0,

	// cyclonev_pll_refclk_select pins
	input [number_of_fplls-1:0] adjpllin,	
	input [number_of_fplls-1:0] cclk,
	input [number_of_fplls-1:0] coreclkin,
	input [number_of_fplls-1:0] extswitch,
	input [number_of_fplls-1:0] iqtxrxclkin,
	input [number_of_fplls-1:0] plliqclkin,
	input [number_of_fplls-1:0] rxiqclkin,
	input [3:0] clkin,
	input [1:0] refiqclk_0,
	input [1:0] refiqclk_1,
	output [number_of_fplls-1:0] clk0bad,
	output [number_of_fplls-1:0] clk1bad,
	output [number_of_fplls-1:0] pllclksel,

// cyclonev_pll_reconfig pins
	input [number_of_fplls-1:0] atpgmode,
	input [number_of_fplls-1:0] clk,
	input [number_of_fplls-1:0] fpllcsrtest,
	input [number_of_fplls-1:0] iocsrclkin,
	input [number_of_fplls-1:0] iocsrdatain,
	input [number_of_fplls-1:0] iocsren,
	input [number_of_fplls-1:0] iocsrrstn,
	input [number_of_fplls-1:0] mdiodis,
	input [number_of_fplls-1:0] phaseen,
	input [number_of_fplls-1:0] read,
	input [number_of_fplls-1:0] rstn,
	input [number_of_fplls-1:0] scanen,
	input [number_of_fplls-1:0] sershiftload,
	input [number_of_fplls-1:0] shiftdonei,
	input [number_of_fplls-1:0] updn,
	input [number_of_fplls-1:0] write,
	input [5:0] addr_0,
	input [1:0] byteen_0,
	input [4:0] cntsel_0,
	input [15:0] din_0,
	output [number_of_fplls-1:0] blockselect,
	output [number_of_fplls-1:0] iocsrdataout,
	output [number_of_fplls-1:0] iocsrenbuf,
	output [number_of_fplls-1:0] iocsrrstnbuf,
	output [number_of_fplls-1:0] phasedone,
	output [15:0] dout_0,
	output [815:0] dprioout_0,

// cyclonev_fractional_pll pins
	input [number_of_fplls-1:0] fbclkfpll,
	input [number_of_fplls-1:0] lvdfbin,
	input [number_of_fplls-1:0] nresync,
	input [number_of_fplls-1:0] pfden,
	input [number_of_fplls-1:0] shiften_fpll,
	input [number_of_fplls-1:0] zdb,
	output [number_of_fplls-1:0] fblvdsout,
	output [number_of_fplls-1:0] lock,
	output [number_of_fplls-1:0] mcntout,
	output [number_of_fplls-1:0] plniotribuf,

// cyclonev_pll_extclk_output pins
	input [number_of_extclks-1:0] clken,
	output [number_of_extclks-1:0] extclk,

// cyclonev_pll_dll_output pins
	input [number_of_dlls-1:0] dll_clkin,
	output [number_of_dlls-1:0] clkout,

// cyclonev_pll_lvds_output pins
	output [number_of_lvds-1:0] loaden,
	output [number_of_lvds-1:0] lvdsclk,

// cyclonev_pll_output_counter pins
	output [number_of_counters-1:0] divclk,
	output [number_of_counters-1:0] cascade_out	
);

////////////////////////////////////////////////////////////////////////////////
// pll_clkin_0_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLKIN_0_SRC_PLL_IQCLK = 4'b1100 ;
localparam PLL_CLKIN_0_SRC_FPLL = 4'b1011 ;
localparam PLL_CLKIN_0_SRC_IQTXRXCLK = 4'b1010 ;
localparam PLL_CLKIN_0_SRC_CMU_IQCLK = 4'b1001 ;
localparam PLL_CLKIN_0_SRC_VSS = 4'b1000 ;
localparam PLL_CLKIN_0_SRC_CLK_3 = 4'b0111 ;
localparam PLL_CLKIN_0_SRC_CLK_2 = 4'b0110 ;
localparam PLL_CLKIN_0_SRC_CLK_1 = 4'b0101 ;
localparam PLL_CLKIN_0_SRC_CLK_0 = 4'b0100 ;
localparam PLL_CLKIN_0_SRC_REF_CLK1 = 4'b0011 ;
localparam PLL_CLKIN_0_SRC_REF_CLK0 = 4'b0010 ;
localparam PLL_CLKIN_0_SRC_ADJ_PLL_CLK = 4'b0001 ;
localparam PLL_CLKIN_0_SRC_CORE_REF_CLK = 4'b0000 ;
localparam local_pll_clkin_0_src_0 = (pll_clkin_0_src_0 == "core_ref_clk") ? PLL_CLKIN_0_SRC_CORE_REF_CLK :
								   (pll_clkin_0_src_0 == "adj_pll_clk") ? PLL_CLKIN_0_SRC_ADJ_PLL_CLK :
								   (pll_clkin_0_src_0 == "ref_clk0") ? PLL_CLKIN_0_SRC_REF_CLK0 :
								   (pll_clkin_0_src_0 == "ref_clk1") ? PLL_CLKIN_0_SRC_REF_CLK1 :
								   (pll_clkin_0_src_0 == "clk_0") ? PLL_CLKIN_0_SRC_CLK_0 :
								   (pll_clkin_0_src_0 == "clk_1") ? PLL_CLKIN_0_SRC_CLK_1 :
								   (pll_clkin_0_src_0 == "clk_2") ? PLL_CLKIN_0_SRC_CLK_2 :
								   (pll_clkin_0_src_0 == "clk_3") ? PLL_CLKIN_0_SRC_CLK_3 :
								   (pll_clkin_0_src_0 == "vss") ? PLL_CLKIN_0_SRC_VSS :
								   (pll_clkin_0_src_0 == "cmu_iqclk") ? PLL_CLKIN_0_SRC_CMU_IQCLK :
								   (pll_clkin_0_src_0 == "iqtxrxclk") ? PLL_CLKIN_0_SRC_IQTXRXCLK :
								   (pll_clkin_0_src_0 == "fpll") ? PLL_CLKIN_0_SRC_FPLL :
								   (pll_clkin_0_src_0 == "pll_iqclk") ? PLL_CLKIN_0_SRC_PLL_IQCLK : PLL_CLKIN_0_SRC_VSS;
localparam local_pll_clkin_0_src_1 = (pll_clkin_0_src_1 == "core_ref_clk") ? PLL_CLKIN_0_SRC_CORE_REF_CLK :
								   (pll_clkin_0_src_1 == "adj_pll_clk") ? PLL_CLKIN_0_SRC_ADJ_PLL_CLK :
								   (pll_clkin_0_src_1 == "ref_clk0") ? PLL_CLKIN_0_SRC_REF_CLK0 :
								   (pll_clkin_0_src_1 == "ref_clk1") ? PLL_CLKIN_0_SRC_REF_CLK1 :
								   (pll_clkin_0_src_1 == "clk_0") ? PLL_CLKIN_0_SRC_CLK_0 :
								   (pll_clkin_0_src_1 == "clk_1") ? PLL_CLKIN_0_SRC_CLK_1 :
								   (pll_clkin_0_src_1 == "clk_2") ? PLL_CLKIN_0_SRC_CLK_2 :
								   (pll_clkin_0_src_1 == "clk_3") ? PLL_CLKIN_0_SRC_CLK_3 :
								   (pll_clkin_0_src_1 == "vss") ? PLL_CLKIN_0_SRC_VSS :
								   (pll_clkin_0_src_1 == "cmu_iqclk") ? PLL_CLKIN_0_SRC_CMU_IQCLK :
								   (pll_clkin_0_src_1 == "iqtxrxclk") ? PLL_CLKIN_0_SRC_IQTXRXCLK :
								   (pll_clkin_0_src_1 == "fpll") ? PLL_CLKIN_0_SRC_FPLL :
								   (pll_clkin_0_src_1 == "pll_iqclk") ? PLL_CLKIN_0_SRC_PLL_IQCLK : PLL_CLKIN_0_SRC_VSS;

								   
////////////////////////////////////////////////////////////////////////////////
// pll_clkin_1_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLKIN_1_SRC_PLL_IQCLK = 4'b1100 ;
localparam PLL_CLKIN_1_SRC_FPLL = 4'b1011 ;
localparam PLL_CLKIN_1_SRC_IQTXRXCLK = 4'b1010 ;
localparam PLL_CLKIN_1_SRC_CMU_IQCLK = 4'b1001 ;
localparam PLL_CLKIN_1_SRC_VSS = 4'b1000 ;
localparam PLL_CLKIN_1_SRC_CLK_3 = 4'b0111 ;
localparam PLL_CLKIN_1_SRC_CLK_2 = 4'b0110 ;
localparam PLL_CLKIN_1_SRC_CLK_1 = 4'b0101 ;
localparam PLL_CLKIN_1_SRC_CLK_0 = 4'b0100 ;
localparam PLL_CLKIN_1_SRC_REF_CLK1 = 4'b0011 ;
localparam PLL_CLKIN_1_SRC_REF_CLK0 = 4'b0010 ;
localparam PLL_CLKIN_1_SRC_ADJ_PLL_CLK = 4'b0001 ;
localparam PLL_CLKIN_1_SRC_CORE_REF_CLK = 4'b0000 ;
localparam local_pll_clkin_1_src_0 = (pll_clkin_1_src_0 == "core_ref_clk") ? PLL_CLKIN_1_SRC_CORE_REF_CLK :
								   (pll_clkin_1_src_0 == "adj_pll_clk") ? PLL_CLKIN_1_SRC_ADJ_PLL_CLK :
								   (pll_clkin_1_src_0 == "ref_clk0") ? PLL_CLKIN_1_SRC_REF_CLK0 :
								   (pll_clkin_1_src_0 == "ref_clk1") ? PLL_CLKIN_1_SRC_REF_CLK1 :
								   (pll_clkin_1_src_0 == "clk_0") ? PLL_CLKIN_1_SRC_CLK_0 :
								   (pll_clkin_1_src_0 == "clk_1") ? PLL_CLKIN_1_SRC_CLK_1 :
								   (pll_clkin_1_src_0 == "clk_2") ? PLL_CLKIN_1_SRC_CLK_2 :
								   (pll_clkin_1_src_0 == "clk_3") ? PLL_CLKIN_1_SRC_CLK_3 :
								   (pll_clkin_1_src_0 == "vss") ? PLL_CLKIN_1_SRC_VSS :
								   (pll_clkin_1_src_0 == "cmu_iqclk") ? PLL_CLKIN_1_SRC_CMU_IQCLK :
								   (pll_clkin_1_src_0 == "iqtxrxclk") ? PLL_CLKIN_1_SRC_IQTXRXCLK :
								   (pll_clkin_1_src_0 == "fpll") ? PLL_CLKIN_1_SRC_FPLL :
								   (pll_clkin_1_src_0 == "pll_iqclk") ? PLL_CLKIN_1_SRC_PLL_IQCLK : PLL_CLKIN_1_SRC_VSS;
localparam local_pll_clkin_1_src_1 = (pll_clkin_1_src_1 == "core_ref_clk") ? PLL_CLKIN_1_SRC_CORE_REF_CLK :
								   (pll_clkin_1_src_1 == "adj_pll_clk") ? PLL_CLKIN_1_SRC_ADJ_PLL_CLK :
								   (pll_clkin_1_src_1 == "ref_clk0") ? PLL_CLKIN_1_SRC_REF_CLK0 :
								   (pll_clkin_1_src_1 == "ref_clk1") ? PLL_CLKIN_1_SRC_REF_CLK1 :
								   (pll_clkin_1_src_1 == "clk_0") ? PLL_CLKIN_1_SRC_CLK_0 :
								   (pll_clkin_1_src_1 == "clk_1") ? PLL_CLKIN_1_SRC_CLK_1 :
								   (pll_clkin_1_src_1 == "clk_2") ? PLL_CLKIN_1_SRC_CLK_2 :
								   (pll_clkin_1_src_1 == "clk_3") ? PLL_CLKIN_1_SRC_CLK_3 :
								   (pll_clkin_1_src_1 == "vss") ? PLL_CLKIN_1_SRC_VSS :
								   (pll_clkin_1_src_1 == "cmu_iqclk") ? PLL_CLKIN_1_SRC_CMU_IQCLK :
								   (pll_clkin_1_src_1 == "iqtxrxclk") ? PLL_CLKIN_1_SRC_IQTXRXCLK :
								   (pll_clkin_1_src_1 == "fpll") ? PLL_CLKIN_1_SRC_FPLL :
								   (pll_clkin_1_src_1 == "pll_iqclk") ? PLL_CLKIN_1_SRC_PLL_IQCLK : PLL_CLKIN_1_SRC_VSS;
								   
////////////////////////////////////////////////////////////////////////////////
// pll_clk_sw_dly_setting
////////////////////////////////////////////////////////////////////////////////
localparam SWITCHOVER_DLY_SETTING = 3'b000 ;
localparam local_pll_clk_sw_dly_0 = pll_clk_sw_dly_0;
localparam local_pll_clk_sw_dly_1 = pll_clk_sw_dly_1;
localparam local_pll_clk_sw_dly_setting_0 = pll_clk_sw_dly_0;
localparam local_pll_clk_sw_dly_setting_1 = pll_clk_sw_dly_1;

////////////////////////////////////////////////////////////////////////////////
// pll_clk_loss_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CLK_LOSS_SW_ENABLED = 1'b1 ;
localparam PLL_CLK_LOSS_SW_BYPS = 1'b0 ;
localparam local_pll_clk_loss_sw_en_0 = (pll_clk_loss_sw_en_0 == "false") ? PLL_CLK_LOSS_SW_BYPS : PLL_CLK_LOSS_SW_ENABLED;
localparam local_pll_clk_loss_sw_en_1 = (pll_clk_loss_sw_en_1 == "false") ? PLL_CLK_LOSS_SW_BYPS : PLL_CLK_LOSS_SW_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_manu_clk_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_MANU_CLK_SW_ENABLED = 1'b1 ;
localparam PLL_MANU_CLK_SW_DISABLED = 1'b0 ;
localparam local_pll_manu_clk_sw_en_0 = (pll_manu_clk_sw_en_0 == "false") ? PLL_MANU_CLK_SW_DISABLED : PLL_MANU_CLK_SW_ENABLED;
localparam local_pll_manu_clk_sw_en_1 = (pll_manu_clk_sw_en_1 == "false") ? PLL_MANU_CLK_SW_DISABLED : PLL_MANU_CLK_SW_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_auto_clk_sw_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_AUTO_CLK_SW_ENABLED = 1'b1 ;
localparam PLL_AUTO_CLK_SW_DISABLED = 1'b0 ;
localparam local_pll_auto_clk_sw_en_0 = (pll_auto_clk_sw_en_0 == "false") ? PLL_AUTO_CLK_SW_DISABLED : PLL_AUTO_CLK_SW_ENABLED; ////////////////////////////////////////////////////////////////////////////////
localparam local_pll_auto_clk_sw_en_1 = (pll_auto_clk_sw_en_1 == "false") ? PLL_AUTO_CLK_SW_DISABLED : PLL_AUTO_CLK_SW_ENABLED; ////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph0_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH0_EN = 1'b1 ;
localparam PLL_VCO_PH0_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph0_en_0 = (pll_vco_ph0_en_0 == "false") ? PLL_VCO_PH0_DIS_EN : PLL_VCO_PH0_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph1_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH1_EN = 1'b1 ;
localparam PLL_VCO_PH1_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph1_en_0 = (pll_vco_ph1_en_0 == "false") ? PLL_VCO_PH1_DIS_EN : PLL_VCO_PH1_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph2_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH2_EN = 1'b1 ;
localparam PLL_VCO_PH2_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph2_en_0 = (pll_vco_ph2_en_0 == "false") ? PLL_VCO_PH2_DIS_EN : PLL_VCO_PH2_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph3_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH3_EN = 1'b1 ;
localparam PLL_VCO_PH3_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph3_en_0 = (pll_vco_ph3_en_0 == "false") ? PLL_VCO_PH3_DIS_EN : PLL_VCO_PH3_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph4_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH4_EN = 1'b1 ;
localparam PLL_VCO_PH4_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph4_en_0 = (pll_vco_ph4_en_0 == "false") ? PLL_VCO_PH4_DIS_EN : PLL_VCO_PH4_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph5_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH5_EN = 1'b1 ;
localparam PLL_VCO_PH5_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph5_en_0 = (pll_vco_ph5_en_0 == "false") ? PLL_VCO_PH5_DIS_EN : PLL_VCO_PH5_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph6_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH6_EN = 1'b1 ;
localparam PLL_VCO_PH6_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph6_en_0 = (pll_vco_ph6_en_0 == "false") ? PLL_VCO_PH6_DIS_EN : PLL_VCO_PH6_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_ph7_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_PH7_EN = 1'b1 ;
localparam PLL_VCO_PH7_DIS_EN = 1'b0 ;
localparam local_pll_vco_ph7_en_0 = (pll_vco_ph7_en_0 == "false") ? PLL_VCO_PH7_DIS_EN : PLL_VCO_PH7_EN;

////////////////////////////////////////////////////////////////////////////////
// pll_enable
////////////////////////////////////////////////////////////////////////////////
localparam PLL_ENABLED = 1'b1 ;
localparam PLL_DISABLED = 1'b0 ;
localparam local_pll_enable_0 = (pll_enable_0 == "true") ? PLL_ENABLED : PLL_DISABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_ctrl_override_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CTRL_ENABLE = 1'b1 ;
localparam PLL_CTRL_DISABLE = 1'b0 ;
localparam local_pll_ctrl_override_setting_0 = (pll_ctrl_override_setting_0 == "false") ? PLL_CTRL_DISABLE : PLL_CTRL_ENABLE;

////////////////////////////////////////////////////////////////////////////////
// pll_fbclk_mux_1
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FBCLK_MUX_1_FBCLK_FPLL = 2'b11 ;
localparam PLL_FBCLK_MUX_1_LVDS = 2'b10 ;
localparam PLL_FBCLK_MUX_1_ZBD = 2'b01 ;
localparam PLL_FBCLK_MUX_1_GLB = 2'b00 ;
localparam local_pll_fbclk_mux_1_0 = (pll_fbclk_mux_1_0 == "glb") ? PLL_FBCLK_MUX_1_GLB :
								   (pll_fbclk_mux_1_0 == "zbd") ? PLL_FBCLK_MUX_1_ZBD :
								   (pll_fbclk_mux_1_0 == "lvds") ? PLL_FBCLK_MUX_1_LVDS : PLL_FBCLK_MUX_1_FBCLK_FPLL;

////////////////////////////////////////////////////////////////////////////////
// pll_fbclk_mux_2
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FBCLK_MUX_2_M_CNT = 1'b1 ;
localparam PLL_FBCLK_MUX_2_FB_1 = 1'b0 ;
localparam local_pll_fbclk_mux_2_0 = (pll_fbclk_mux_2_0 == "fb_1") ? PLL_FBCLK_MUX_2_FB_1 : PLL_FBCLK_MUX_2_M_CNT;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_BYPASS_ENABLED = 1'b1 ;
localparam PLL_N_CNT_DIV_ENABLED = 1'b0 ;
localparam local_pll_n_cnt_bypass_en_0 = (pll_n_cnt_bypass_en_0 == "false") ? PLL_N_CNT_DIV_ENABLED : PLL_N_CNT_BYPASS_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_lo_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_LO_VALUE = 8'h01 ;
localparam local_pll_n_cnt_lo_div_0 = pll_n_cnt_lo_div_0;
localparam local_pll_n_cnt_lo_div_setting_0 = pll_n_cnt_lo_div_0;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_hi_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_HI_VALUE = 8'h01 ;
localparam local_pll_n_cnt_hi_div_0 = pll_n_cnt_hi_div_0;
localparam local_pll_n_cnt_hi_div_setting_0 = pll_n_cnt_hi_div_0;

////////////////////////////////////////////////////////////////////////////////
// pll_n_cnt_odd_div_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_N_CNT_EVEN_DUTY_ENABLED = 1'b1 ;
localparam PLL_N_CNT_EVEN_DUTY_DISABLED = 1'b0 ;
localparam local_pll_n_cnt_odd_div_duty_en_0 = (pll_n_cnt_odd_div_duty_en_0 == "false") ? PLL_N_CNT_EVEN_DUTY_DISABLED : PLL_N_CNT_EVEN_DUTY_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_tclk_sel
////////////////////////////////////////////////////////////////////////////////
localparam PLL_TCLK_M_SRC = 1'b1 ;
localparam PLL_TCLK_N_SRC = 1'b0 ;
localparam local_pll_tclk_sel_0 = (pll_tclk_sel_0 == "cdb_pll_tclk_sel_m_src") ? PLL_TCLK_M_SRC : PLL_TCLK_N_SRC;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_odd_div_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_EVEN_DUTY_ENABLED = 1'b1 ;
localparam PLL_M_CNT_EVEN_DUTY_DISABLED = 1'b0 ;
localparam local_pll_m_cnt_odd_div_duty_en_0 = (pll_m_cnt_odd_div_duty_en_0 == "false") ? PLL_M_CNT_EVEN_DUTY_DISABLED : PLL_M_CNT_EVEN_DUTY_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_BYPASS_ENABLED = 1'b1 ;
localparam PLL_M_CNT_DIV_ENABLED = 1'b0 ;
localparam local_pll_m_cnt_bypass_en_0 = (pll_m_cnt_bypass_en_0 == "false") ? PLL_M_CNT_DIV_ENABLED : PLL_M_CNT_BYPASS_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_hi_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_HI_VALUE = 8'h01 ;
localparam local_pll_m_cnt_hi_div_0 = pll_m_cnt_hi_div_0;
localparam local_pll_m_cnt_hi_div_setting_0 = pll_m_cnt_hi_div_0;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_in_src
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_IN_SRC_VSS = 2'b11 ;
localparam PLL_M_CNT_IN_SRC_TEST_CLK = 2'b10 ;
localparam PLL_M_CNT_IN_SRC_FBLVDS = 2'b01 ;
localparam PLL_M_CNT_IN_SRC_PH_MUX_CLK = 2'b00 ;
localparam local_pll_m_cnt_in_src_0 = (pll_m_cnt_in_src_0 == "ph_mux_clk") ? PLL_M_CNT_IN_SRC_PH_MUX_CLK :
									(pll_m_cnt_in_src_0 == "fblvds") ? PLL_M_CNT_IN_SRC_FBLVDS :
									(pll_m_cnt_in_src_0 == "test_clk") ? PLL_M_CNT_IN_SRC_TEST_CLK : PLL_M_CNT_IN_SRC_VSS;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_lo_div_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_LO_VALUE = 8'h01 ;
localparam local_pll_m_cnt_lo_div_0 = pll_m_cnt_lo_div_0;
localparam local_pll_m_cnt_lo_div_setting_0 = pll_m_cnt_lo_div_0;

////////////////////////////////////////////////////////////////////////////////
// pll_m_cnt_prst_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_M_CNT_PRST_VALUE = 8'h01 ;
localparam local_pll_m_cnt_prst_0 = pll_m_cnt_prst_0;
localparam local_pll_m_cnt_prst_setting_0 = pll_m_cnt_prst_0;

////////////////////////////////////////////////////////////////////////////////
// pll_unlock_fltr_cfg_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_UNLOCK_COUNTER_SETTING = 3'b000 ;
localparam local_pll_unlock_fltr_cfg_0 = pll_unlock_fltr_cfg_0;
localparam local_pll_unlock_fltr_cfg_setting_0 = pll_unlock_fltr_cfg_0;

////////////////////////////////////////////////////////////////////////////////
// pll_lock_fltr_cfg_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_LOCK_COUNTER_SETTING = 12'h001 ;
localparam local_pll_lock_fltr_cfg_0 = pll_lock_fltr_cfg_0;
localparam local_pll_lock_fltr_cfg_setting_0 = pll_lock_fltr_cfg_0;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_in_src
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_IN_SRC_TEST_CLK1 = 2'b11 ;
localparam C_CNT_IN_SRC_TEST_CLK0 = 2'b10 ;
localparam C_CNT_IN_SRC_CSCD_CLK = 2'b01 ;
localparam C_CNT_IN_SRC_PH_MUX_CLK = 2'b00 ;
localparam local_c_cnt_in_src_0 = (c_cnt_in_src_0 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_0 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_0 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_1 = (c_cnt_in_src_1 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_1 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_1 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_2 = (c_cnt_in_src_2 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_2 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_2 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_3 = (c_cnt_in_src_3 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_3 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_3 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_4 = (c_cnt_in_src_4 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_4 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_4 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_5 = (c_cnt_in_src_5 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_5 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_5 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_6 = (c_cnt_in_src_6 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_6 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_6 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_7 = (c_cnt_in_src_7 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_7 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_7 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
localparam local_c_cnt_in_src_8 = (c_cnt_in_src_8 == "ph_mux_clk") ? C_CNT_IN_SRC_PH_MUX_CLK :
								(c_cnt_in_src_8 == "cscd_clk") ? C_CNT_IN_SRC_CSCD_CLK :
								(c_cnt_in_src_8 == "test_clk0") ? C_CNT_IN_SRC_TEST_CLK0 : C_CNT_IN_SRC_TEST_CLK1;
////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_bypass_en
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_DIV_ENABLED = 0 ;
localparam local_dprio0_cnt_bypass_en_0 = (dprio0_cnt_bypass_en_0 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_0 = (dprio0_cnt_bypass_en_0 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_1 = (dprio0_cnt_bypass_en_1 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_1 = (dprio0_cnt_bypass_en_1 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_2 = (dprio0_cnt_bypass_en_2 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_2 = (dprio0_cnt_bypass_en_2 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_3 = (dprio0_cnt_bypass_en_3 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_3 = (dprio0_cnt_bypass_en_3 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_4 = (dprio0_cnt_bypass_en_4 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_4 = (dprio0_cnt_bypass_en_4 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_5 = (dprio0_cnt_bypass_en_5 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_5 = (dprio0_cnt_bypass_en_5 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_6 = (dprio0_cnt_bypass_en_6 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_6 = (dprio0_cnt_bypass_en_6 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_7 = (dprio0_cnt_bypass_en_7 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_7 = (dprio0_cnt_bypass_en_7 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_8 = (dprio0_cnt_bypass_en_8 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;
localparam local_dprio0_cnt_bypass_en_user_8 = (dprio0_cnt_bypass_en_8 == "false") ? DPRIO0_CNT_DIV_ENABLED : !DPRIO0_CNT_DIV_ENABLED;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_prst
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_PRST_VALUE = 1 ;
localparam local_c_cnt_prst_0 = c_cnt_prst_0;
localparam local_c_cnt_prst_user_0 = c_cnt_prst_0;
localparam local_c_cnt_prst_1 = c_cnt_prst_1;
localparam local_c_cnt_prst_user_1 = c_cnt_prst_1;
localparam local_c_cnt_prst_2 = c_cnt_prst_2;
localparam local_c_cnt_prst_user_2 = c_cnt_prst_2;
localparam local_c_cnt_prst_3 = c_cnt_prst_3;
localparam local_c_cnt_prst_user_3 = c_cnt_prst_3;
localparam local_c_cnt_prst_4 = c_cnt_prst_4;
localparam local_c_cnt_prst_user_4 = c_cnt_prst_4;
localparam local_c_cnt_prst_5 = c_cnt_prst_5;
localparam local_c_cnt_prst_user_5 = c_cnt_prst_5;
localparam local_c_cnt_prst_6 = c_cnt_prst_6;
localparam local_c_cnt_prst_user_6 = c_cnt_prst_6;
localparam local_c_cnt_prst_7 = c_cnt_prst_7;
localparam local_c_cnt_prst_user_7 = c_cnt_prst_7;
localparam local_c_cnt_prst_8 = c_cnt_prst_8;
localparam local_c_cnt_prst_user_8 = c_cnt_prst_8;

////////////////////////////////////////////////////////////////////////////////
// c_cnt_ph_mux_prst
////////////////////////////////////////////////////////////////////////////////
localparam C_CNT_PH_MUX_PRST_VALUE = 0 ;
localparam local_c_cnt_ph_mux_prst_0 = c_cnt_ph_mux_prst_0;
localparam local_c_cnt_ph_mux_prst_user_0 = c_cnt_ph_mux_prst_0;
localparam local_c_cnt_ph_mux_prst_1 = c_cnt_ph_mux_prst_1;
localparam local_c_cnt_ph_mux_prst_user_1 = c_cnt_ph_mux_prst_1;
localparam local_c_cnt_ph_mux_prst_2 = c_cnt_ph_mux_prst_2;
localparam local_c_cnt_ph_mux_prst_user_2 = c_cnt_ph_mux_prst_2;
localparam local_c_cnt_ph_mux_prst_3 = c_cnt_ph_mux_prst_3;
localparam local_c_cnt_ph_mux_prst_user_3 = c_cnt_ph_mux_prst_3;
localparam local_c_cnt_ph_mux_prst_4 = c_cnt_ph_mux_prst_4;
localparam local_c_cnt_ph_mux_prst_user_4 = c_cnt_ph_mux_prst_4;
localparam local_c_cnt_ph_mux_prst_5 = c_cnt_ph_mux_prst_5;
localparam local_c_cnt_ph_mux_prst_user_5 = c_cnt_ph_mux_prst_5;
localparam local_c_cnt_ph_mux_prst_6 = c_cnt_ph_mux_prst_6;
localparam local_c_cnt_ph_mux_prst_user_6 = c_cnt_ph_mux_prst_6;
localparam local_c_cnt_ph_mux_prst_7 = c_cnt_ph_mux_prst_7;
localparam local_c_cnt_ph_mux_prst_user_7 = c_cnt_ph_mux_prst_7;
localparam local_c_cnt_ph_mux_prst_8 = c_cnt_ph_mux_prst_8;
localparam local_c_cnt_ph_mux_prst_user_8 = c_cnt_ph_mux_prst_8;

/////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_hi_div
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_HI_DIV_VALUE = 0 ;
localparam local_dprio0_cnt_hi_div_0 = dprio0_cnt_hi_div_0;
localparam local_dprio0_cnt_hi_div_user_0 = dprio0_cnt_hi_div_0;
localparam local_dprio0_cnt_hi_div_1 = dprio0_cnt_hi_div_1;
localparam local_dprio0_cnt_hi_div_user_1 = dprio0_cnt_hi_div_1;
localparam local_dprio0_cnt_hi_div_2 = dprio0_cnt_hi_div_2;
localparam local_dprio0_cnt_hi_div_user_2 = dprio0_cnt_hi_div_2;
localparam local_dprio0_cnt_hi_div_3 = dprio0_cnt_hi_div_3;
localparam local_dprio0_cnt_hi_div_user_3 = dprio0_cnt_hi_div_3;
localparam local_dprio0_cnt_hi_div_4 = dprio0_cnt_hi_div_4;
localparam local_dprio0_cnt_hi_div_user_4 = dprio0_cnt_hi_div_4;
localparam local_dprio0_cnt_hi_div_5 = dprio0_cnt_hi_div_5;
localparam local_dprio0_cnt_hi_div_user_5 = dprio0_cnt_hi_div_5;
localparam local_dprio0_cnt_hi_div_6 = dprio0_cnt_hi_div_6;
localparam local_dprio0_cnt_hi_div_user_6 = dprio0_cnt_hi_div_6;
localparam local_dprio0_cnt_hi_div_7 = dprio0_cnt_hi_div_7;
localparam local_dprio0_cnt_hi_div_user_7 = dprio0_cnt_hi_div_7;
localparam local_dprio0_cnt_hi_div_8 = dprio0_cnt_hi_div_8;
localparam local_dprio0_cnt_hi_div_user_8 = dprio0_cnt_hi_div_8;

///////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_lo_div
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_LO_DIV_VALUE = 0 ;
localparam local_dprio0_cnt_lo_div_0 = dprio0_cnt_lo_div_0;
localparam local_dprio0_cnt_lo_div_user_0 = dprio0_cnt_lo_div_0;
localparam local_dprio0_cnt_lo_div_1 = dprio0_cnt_lo_div_1;
localparam local_dprio0_cnt_lo_div_user_1 = dprio0_cnt_lo_div_1;
localparam local_dprio0_cnt_lo_div_2 = dprio0_cnt_lo_div_2;
localparam local_dprio0_cnt_lo_div_user_2 = dprio0_cnt_lo_div_2;
localparam local_dprio0_cnt_lo_div_3 = dprio0_cnt_lo_div_3;
localparam local_dprio0_cnt_lo_div_user_3 = dprio0_cnt_lo_div_3;
localparam local_dprio0_cnt_lo_div_4 = dprio0_cnt_lo_div_4;
localparam local_dprio0_cnt_lo_div_user_4 = dprio0_cnt_lo_div_4;
localparam local_dprio0_cnt_lo_div_5 = dprio0_cnt_lo_div_5;
localparam local_dprio0_cnt_lo_div_user_5 = dprio0_cnt_lo_div_5;
localparam local_dprio0_cnt_lo_div_6 = dprio0_cnt_lo_div_6;
localparam local_dprio0_cnt_lo_div_user_6 = dprio0_cnt_lo_div_6;
localparam local_dprio0_cnt_lo_div_7 = dprio0_cnt_lo_div_7;
localparam local_dprio0_cnt_lo_div_user_7 = dprio0_cnt_lo_div_7;
localparam local_dprio0_cnt_lo_div_8 = dprio0_cnt_lo_div_8;
localparam local_dprio0_cnt_lo_div_user_8 = dprio0_cnt_lo_div_8;

////////////////////////////////////////////////////////////////////////////////
// dprio0_cnt_odd_div_even_duty_en
////////////////////////////////////////////////////////////////////////////////
localparam DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED = 0 ;
localparam local_dprio0_cnt_odd_div_even_duty_en_0 = (dprio0_cnt_odd_div_even_duty_en_0 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_0 = (dprio0_cnt_odd_div_even_duty_en_0 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_1 = (dprio0_cnt_odd_div_even_duty_en_1 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_1 = (dprio0_cnt_odd_div_even_duty_en_1 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_2 = (dprio0_cnt_odd_div_even_duty_en_2 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_2 = (dprio0_cnt_odd_div_even_duty_en_2 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_3 = (dprio0_cnt_odd_div_even_duty_en_3 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_3 = (dprio0_cnt_odd_div_even_duty_en_3 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_4 = (dprio0_cnt_odd_div_even_duty_en_4 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_4 = (dprio0_cnt_odd_div_even_duty_en_4 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_5 = (dprio0_cnt_odd_div_even_duty_en_5 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_5 = (dprio0_cnt_odd_div_even_duty_en_5 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_6 = (dprio0_cnt_odd_div_even_duty_en_6 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_6 = (dprio0_cnt_odd_div_even_duty_en_6 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_7 = (dprio0_cnt_odd_div_even_duty_en_7 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_7 = (dprio0_cnt_odd_div_even_duty_en_7 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_8 = (dprio0_cnt_odd_div_even_duty_en_8 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;
localparam local_dprio0_cnt_odd_div_even_duty_en_user_8 = (dprio0_cnt_odd_div_even_duty_en_8 == "false") ? DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED : !DPRIO0_CNT_ODD_DIV_EVEN_DUTY_DISABLED;


////////////////////////////////////////////////////////////////////////////////
// pll_bwctrl
////////////////////////////////////////////////////////////////////////////////
localparam PLL_BW_RES_UNUSED5 = 4'b1111 ;
localparam PLL_BW_RES_UNUSED4 = 4'b1110 ;
localparam PLL_BW_RES_UNUSED3 = 4'b1101 ;
localparam PLL_BW_RES_UNUSED2 = 4'b1100 ;
localparam PLL_BW_RES_UNUSED1 = 4'b1011 ;
localparam PLL_BW_RES_0P5K = 4'b1010 ;
localparam PLL_BW_RES_1K = 4'b1001 ;
localparam PLL_BW_RES_2K = 4'b1000 ;
localparam PLL_BW_RES_4K = 4'b0111 ;
localparam PLL_BW_RES_6K = 4'b0110 ;
localparam PLL_BW_RES_8K = 4'b0101 ;
localparam PLL_BW_RES_10K = 4'b0100 ;
localparam PLL_BW_RES_12K = 4'b0011 ;
localparam PLL_BW_RES_14K = 4'b0010 ;
localparam PLL_BW_RES_16K = 4'b0001 ;
localparam PLL_BW_RES_18K = 4'b0000 ;
localparam local_pll_bwctrl_0 = (pll_bwctrl_0 == 18000) ? PLL_BW_RES_18K :
							  (pll_bwctrl_0 == 16000) ? PLL_BW_RES_16K :
							  (pll_bwctrl_0 == 14000) ? PLL_BW_RES_14K :
							  (pll_bwctrl_0 == 12000) ? PLL_BW_RES_12K :
							  (pll_bwctrl_0 == 10000) ? PLL_BW_RES_10K :
							  (pll_bwctrl_0 == 8000) ? PLL_BW_RES_8K :
							  (pll_bwctrl_0 == 6000) ? PLL_BW_RES_6K :
							  (pll_bwctrl_0 == 4000) ? PLL_BW_RES_4K :
							  (pll_bwctrl_0 == 2000) ? PLL_BW_RES_2K :
							  (pll_bwctrl_0 == 1000) ? PLL_BW_RES_1K : 
							  (pll_bwctrl_0 == 500) ? PLL_BW_RES_0P5K : PLL_BW_RES_UNUSED1;


////////////////////////////////////////////////////////////////////////////////
// pll_cp_current
////////////////////////////////////////////////////////////////////////////////
localparam PLL_CP_UNUSED3 = 3'b111 ;
localparam PLL_CP_UNUSED2 = 3'b110 ;
localparam PLL_CP_UNUSED1 = 3'b101 ;
localparam PLL_CP_40UA = 3'b100 ;
localparam PLL_CP_30UA = 3'b011 ;
localparam PLL_CP_20UA = 3'b010 ;
localparam PLL_CP_10UA = 3'b001 ;
localparam PLL_CP_5UA = 3'b000 ;
localparam local_pll_cp_current_0 = (pll_cp_current_0 == 5) ? PLL_CP_5UA :
								  (pll_cp_current_0 == 10) ? PLL_CP_10UA :
								  (pll_cp_current_0 == 20) ? PLL_CP_20UA :
								  (pll_cp_current_0 == 30) ? PLL_CP_30UA :
								  (pll_cp_current_0 == 40) ? PLL_CP_40UA : PLL_CP_UNUSED1;

////////////////////////////////////////////////////////////////////////////////
// pll_vco_div
////////////////////////////////////////////////////////////////////////////////
localparam PLL_VCO_DIV_1300 = 1'b1 ;
localparam PLL_VCO_DIV_600 = 1'b0 ;
localparam local_pll_vco_div_0 = (pll_vco_div_0 == 1) ? PLL_VCO_DIV_600 : PLL_VCO_DIV_1300;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_division_setting
////////////////////////////////////////////////////////////////////////////////
localparam PLL_FRACTIONAL_DIVIDE_VALUE = 32'h00000000 ;
localparam local_pll_fractional_division_0 = pll_fractional_division_0;
localparam local_pll_fractional_division_setting_0 = pll_fractional_division_0;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_value_ready
////////////////////////////////////////////////////////////////////////////////
localparam PLL_K_READY = 1'b1 ;
localparam PLL_K_NOT_READY = 1'b0 ;
localparam local_pll_fractional_value_ready_0 = (pll_fractional_value_ready_0 == "true") ? PLL_K_READY : PLL_K_NOT_READY;

////////////////////////////////////////////////////////////////////////////////
// pll_dsm_out_sel
////////////////////////////////////////////////////////////////////////////////
localparam PLL_DSM_3RD_ORDER = 2'b11 ;
localparam PLL_DSM_2ND_ORDER = 2'b10 ;
localparam PLL_DSM_1ST_ORDER = 2'b01 ;
localparam PLL_DSM_DISABLE = 2'b00 ;
localparam local_pll_dsm_out_sel_0 = (pll_dsm_out_sel_0 == "disable") ? PLL_DSM_DISABLE :
								   (pll_dsm_out_sel_0 == "1st_order") ? PLL_DSM_1ST_ORDER :
								   (pll_dsm_out_sel_0 == "2nd_order") ? PLL_DSM_2ND_ORDER : PLL_DSM_3RD_ORDER;

////////////////////////////////////////////////////////////////////////////////
// pll_fractional_carry_out
////////////////////////////////////////////////////////////////////////////////
localparam PLL_COUT_32B = 2'b11 ;
localparam PLL_COUT_24B = 2'b10 ;
localparam PLL_COUT_16B = 2'b01 ;
localparam PLL_COUT_8B = 2'b00 ;
localparam local_pll_fractional_carry_out_0 = (pll_fractional_carry_out_0 == 8) ? PLL_COUT_8B :
											(pll_fractional_carry_out_0 == 16) ? PLL_COUT_16B :
											(pll_fractional_carry_out_0 == 24) ? PLL_COUT_24B : PLL_COUT_32B;
											
////////////////////////////////////////////////////////////////////////////////
// pll_dsm_dither
////////////////////////////////////////////////////////////////////////////////
localparam PLL_DITHER_3 = 2'b11 ;
localparam PLL_DITHER_2 = 2'b10 ;
localparam PLL_DITHER_1 = 2'b01 ;
localparam PLL_DITHER_DISABLE = 2'b00 ;
localparam local_pll_dsm_dither_0 = (pll_dsm_dither_0 == "disable") ? PLL_DITHER_DISABLE :
								  (pll_dsm_dither_0 == "pattern1") ? PLL_DITHER_1 :
								  (pll_dsm_dither_0 == "pattern2") ? PLL_DITHER_2 : PLL_DITHER_3;

////////////////////////////////////////////////////////////////////////////////
// pll_ecn_bypass
////////////////////////////////////////////////////////////////////////////////
localparam PLL_ECN_BYPASS_ENABLE = 1'b1 ;
localparam PLL_ECN_BYPASS_DISABLE = 1'b0 ;
localparam local_pll_ecn_bypass_0 = (pll_ecn_bypass_0 == "false") ? PLL_ECN_BYPASS_DISABLE : PLL_ECN_BYPASS_ENABLE;

								  
wire [1:0] fbclk;
	cyclonev_ffpll_reconfig #(
		.P_XCLKIN_MUX_SO_0__PLL_CLKIN_0_SRC(local_pll_clkin_0_src_0),
		.P_XCLKIN_MUX_SO_0__PLL_CLKIN_1_SRC(local_pll_clkin_1_src_0),
        .P_XCLKIN_MUX_SO_0__PLL_CLK_SW_DLY(local_pll_clk_sw_dly_0), 
        .P_XCLKIN_MUX_SO_0__PLL_CLK_SW_DLY_SETTING(local_pll_clk_sw_dly_0), 	
        .P_XCLKIN_MUX_SO_0__PLL_MANU_CLK_SW_EN(local_pll_manu_clk_sw_en_0),
        .P_XCLKIN_MUX_SO_0__PLL_AUTO_CLK_SW_EN(local_pll_auto_clk_sw_en_0),
        .P_XCLKIN_MUX_SO_0__PLL_CLK_LOSS_SW_EN(local_pll_clk_loss_sw_en_0),
    		
        .P_XFPLL_0__PLL_VCO_PH7_EN(local_pll_vco_ph7_en_0),
		.P_XFPLL_0__PLL_VCO_PH6_EN(local_pll_vco_ph6_en_0),
		.P_XFPLL_0__PLL_VCO_PH5_EN(local_pll_vco_ph5_en_0),
		.P_XFPLL_0__PLL_VCO_PH4_EN(local_pll_vco_ph4_en_0),
		.P_XFPLL_0__PLL_VCO_PH3_EN(local_pll_vco_ph3_en_0),
		.P_XFPLL_0__PLL_VCO_PH2_EN(local_pll_vco_ph2_en_0),
		.P_XFPLL_0__PLL_VCO_PH1_EN(local_pll_vco_ph1_en_0),
		.P_XFPLL_0__PLL_VCO_PH0_EN(local_pll_vco_ph0_en_0),
		.P_XFPLL_0__PLL_ENABLE(local_pll_enable_0),
		.P_XFPLL_0__PLL_CTRL_OVERRIDE_SETTING(local_pll_ctrl_override_setting_0),
		.P_XFPLL_0__PLL_FBCLK_MUX_2(local_pll_fbclk_mux_2_0),
		.P_XFPLL_0__PLL_FBCLK_MUX_1(local_pll_fbclk_mux_1_0),
		.P_XFPLL_0__PLL_N_CNT_BYPASS_EN(local_pll_n_cnt_bypass_en_0),
		.P_XFPLL_0__PLL_N_CNT_LO_DIV_SETTING(local_pll_n_cnt_lo_div_setting_0),
		.P_XFPLL_0__PLL_N_CNT_LO_DIV(local_pll_n_cnt_lo_div_0),
		.P_XFPLL_0__PLL_N_CNT_HI_DIV_SETTING(local_pll_n_cnt_hi_div_setting_0),
		.P_XFPLL_0__PLL_N_CNT_HI_DIV(local_pll_n_cnt_hi_div_0),
		.P_XFPLL_0__PLL_N_CNT_ODD_DIV_DUTY_EN(local_pll_n_cnt_odd_div_duty_en_0),
		.P_XFPLL_0__PLL_TCLK_SEL(local_pll_tclk_sel_0),
		.P_XFPLL_0__PLL_M_CNT_ODD_DIV_DUTY_EN(local_pll_m_cnt_odd_div_duty_en_0),
		.P_XFPLL_0__PLL_M_CNT_BYPASS_EN(local_pll_m_cnt_bypass_en_0),
		.P_XFPLL_0__PLL_M_CNT_IN_SRC(local_pll_m_cnt_in_src_0),
		.P_XFPLL_0__PLL_M_CNT_LO_DIV_SETTING(local_pll_m_cnt_lo_div_setting_0),
		.P_XFPLL_0__PLL_M_CNT_LO_DIV(local_pll_m_cnt_lo_div_0),
		.P_XFPLL_0__PLL_M_CNT_HI_DIV_SETTING(local_pll_m_cnt_hi_div_setting_0),
		.P_XFPLL_0__PLL_M_CNT_HI_DIV(local_pll_m_cnt_hi_div_0),
		.P_XFPLL_0__PLL_M_CNT_PRST(local_pll_m_cnt_prst_0),
		.P_XFPLL_0__PLL_M_CNT_PRST_SETTING(local_pll_m_cnt_prst_setting_0),
		.P_XFPLL_0__PLL_UNLOCK_FLTR_CFG_SETTING(local_pll_unlock_fltr_cfg_setting_0),
		.P_XFPLL_0__PLL_UNLOCK_FLTR_CFG(local_pll_unlock_fltr_cfg_0),
		.P_XFPLL_0__PLL_LOCK_FLTR_CFG_SETTING(local_pll_lock_fltr_cfg_setting_0),
		.P_XFPLL_0__PLL_LOCK_FLTR_CFG(local_pll_lock_fltr_cfg_0),
		.P_XFPLL_0__PLL_DSM_OUT_SEL(local_pll_dsm_out_sel_0),
		.P_XFPLL_0__PLL_FRACTIONAL_DIVISION_SETTING(local_pll_fractional_division_setting_0),
		.P_XFPLL_0__PLL_FRACTIONAL_DIVISION(local_pll_fractional_division_0),
		.P_XFPLL_0__PLL_FRACTIONAL_VALUE_READY(local_pll_fractional_value_ready_0),
		.P_XFPLL_0__PLL_FRACTIONAL_CARRY_OUT(local_pll_fractional_carry_out_0),
		.P_XFPLL_0__PLL_ECN_BYPASS(local_pll_ecn_bypass_0),
		.P_XFPLL_0__PLL_DSM_DITHER(local_pll_dsm_dither_0),
        .P_XFPLL_0__PLL_VCO_DIV(1'b1),
        .P_XFPLL_0__PLL_CP_CURRENT(local_pll_cp_current_0),
        .P_XFPLL_0__PLL_BWCTRL(local_pll_bwctrl_0),
		
        .P_X18CCNTS__XCCNT_0__C_CNT_IN_SRC(local_c_cnt_in_src_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PRST(local_c_cnt_prst_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PRST_USER(local_c_cnt_prst_user_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_0),
		.P_X18CCNTS__XCCNT_0__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_0),
		.P_X18CCNTS__XCCNT_0__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_0),
		.P_X18CCNTS__XCCNT_1__C_CNT_IN_SRC(local_c_cnt_in_src_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PRST(local_c_cnt_prst_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PRST_USER(local_c_cnt_prst_user_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_1),
		.P_X18CCNTS__XCCNT_1__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_1),
		.P_X18CCNTS__XCCNT_1__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_1),
		.P_X18CCNTS__XCCNT_2__C_CNT_IN_SRC(local_c_cnt_in_src_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PRST(local_c_cnt_prst_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PRST_USER(local_c_cnt_prst_user_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_2),
		.P_X18CCNTS__XCCNT_2__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_2),
		.P_X18CCNTS__XCCNT_2__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_2),
		.P_X18CCNTS__XCCNT_3__C_CNT_IN_SRC(local_c_cnt_in_src_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PRST(local_c_cnt_prst_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PRST_USER(local_c_cnt_prst_user_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_3),
		.P_X18CCNTS__XCCNT_3__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_3),
		.P_X18CCNTS__XCCNT_3__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_3),
		.P_X18CCNTS__XCCNT_4__C_CNT_IN_SRC(local_c_cnt_in_src_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PRST(local_c_cnt_prst_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PRST_USER(local_c_cnt_prst_user_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_4),
		.P_X18CCNTS__XCCNT_4__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_4),
		.P_X18CCNTS__XCCNT_4__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_4),
		.P_X18CCNTS__XCCNT_5__C_CNT_IN_SRC(local_c_cnt_in_src_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PRST(local_c_cnt_prst_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PRST_USER(local_c_cnt_prst_user_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_5),
		.P_X18CCNTS__XCCNT_5__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_5),
		.P_X18CCNTS__XCCNT_5__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_5),
		.P_X18CCNTS__XCCNT_6__C_CNT_IN_SRC(local_c_cnt_in_src_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PRST(local_c_cnt_prst_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PRST_USER(local_c_cnt_prst_user_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_6),
		.P_X18CCNTS__XCCNT_6__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_6),
		.P_X18CCNTS__XCCNT_6__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_6),
		.P_X18CCNTS__XCCNT_7__C_CNT_IN_SRC(local_c_cnt_in_src_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PRST(local_c_cnt_prst_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PRST_USER(local_c_cnt_prst_user_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_7),
		.P_X18CCNTS__XCCNT_7__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_7),
		.P_X18CCNTS__XCCNT_7__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_7),
		.P_X18CCNTS__XCCNT_8__C_CNT_IN_SRC(local_c_cnt_in_src_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_BYPASS_EN(local_dprio0_cnt_bypass_en_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_BYPASS_EN_USER(local_dprio0_cnt_bypass_en_user_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PRST(local_c_cnt_prst_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PRST_USER(local_c_cnt_prst_user_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PH_MUX_PRST(local_c_cnt_ph_mux_prst_8),
		.P_X18CCNTS__XCCNT_8__C_CNT_PH_MUX_PRST_USER(local_c_cnt_ph_mux_prst_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_LO_DIV(local_dprio0_cnt_lo_div_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_LO_DIV_USER(local_dprio0_cnt_lo_div_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_HI_DIV(local_dprio0_cnt_hi_div_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_HI_DIV_USER(local_dprio0_cnt_hi_div_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN_USER(local_dprio0_cnt_odd_div_even_duty_en_user_8),
		.P_X18CCNTS__XCCNT_8__DPRIO0_CNT_ODD_DIV_EVEN_DUTY_EN(local_dprio0_cnt_odd_div_even_duty_en_8)
				
	) cyclonev_ffpll_inst (
	  // cyclonev_pll_dpa_output pins
	  .dpaclk0_i(phout_0),
	  
	  // cyclonev_pll_refclk_select pins
	  .pll_cas_in0(adjpllin[0]),
	  .coreclk0(coreclkin[0]),	  	  
	  .coreclk1(cclk[0]),
	  .extswitch0(extswitch[0]),
	  .iqtxrxclk_fpll0(iqtxrxclkin[0]),
	  .ref_iqclk_fpll0(plliqclkin[0]),
	  .rx_iqclk_fpll0(rxiqclkin[0]),
	  .clkin(clkin),
	  .refclk_fpll0(refiqclk_0[0]),
	  .clk0_bad0(clk0bad[0]),
	  .clk1_bad0(clk1bad[0]),
	  .clksel0(pllclksel[0]),

	  // cyclonev_pll_reconfig pins
	  .atpgmode0(atpgmode[0]),
	  .dprio0_clk(clk[0]),
	  .ffpll_csr_test0(fpllcsrtest[0]),
	  .iocsr_clkin(iocsrclkin[0]),
	  .iocsr_datain(iocsrdatain[0]),
	  .dprio0_mdio_dis(mdiodis[0]),
	  .phase_en0(phaseen[0]),
	  .dprio0_read(read[0]),
	  .dprio0_rst_n(rstn[0]),
	  .scanen0(scanen[0]),
	  .dprio0_ser_shift_load(sershiftload[0]),
	  .up_dn0(updn[0]),
	  .dprio0_write(write[0]),
	  .dprio0_reg_addr(addr_0),
	  .dprio0_byte_en(byteen_0),
	  .cnt_sel0(cntsel_0),
	  .dprio0_writedata(din_0),
	  .dprio0_block_select(blockselect[0]),
	  .iocsr_dataout(iocsrdataout[0]),
	  .phase_done0(phasedone[0]),
	  .dprio0_readdata(dout_0),
	  
	  // cyclonev_fractional_pll pins
          .pllmout0(fbclk[0]),
          .fbclk_in0(fbclk[0]),
	  .fbclk_fpll0(fbclkfpll[0]),
	  .fblvds_in0(lvdfbin[0]),
	  .nreset0(nresync[0]),
	  .pfden0(pfden[0]),
	  .zdb_in0(zdb[0]),
	  .fblvds_out0(fblvdsout[0]),
	  .lock0(lock[0]),
	  
	  // cyclonev_pll_extclk_output pins
	  .clken(clken),
	  .extclk(extclk),
	  
	  // cyclonev_pll_dll_output pins
	  .plldout0(clkout[0]),
	  
	  // cyclonev_pll_lvds_output pins
	  .loaden0({loaden[1], loaden[0]}),
	  .loaden1({loaden[1], loaden[0]}),
	  .lvds_clk0({lvdsclk[1], lvdsclk[0]}),
	  .lvds_clk1({lvdsclk[1], lvdsclk[0]}),
	  
	  // cyclonev_pll_output_counter pins
	  .divclk(divclk),
	  .pll_cas_out1(),
	  // others
	  .ioplniotri(nresync[0]),
	  .nfrzdrv(nresync[0]),
	  .pllbias(1'b1)
	);	

	// assign cascade_out to divclk	// This is used as a workaround in RTL simulation as cascade_out needs to be output counter location dependent
	assign cascade_out = divclk;
endmodule
`ifdef GENERIC_PLL_TIMESCALE_1_FS
  `timescale 1 fs / 1 fs

`elsif GENERIC_PLL_TIMESCALE_10_FS
  `timescale 10 fs / 10 fs

`elsif GENERIC_PLL_TIMESCALE_100_FS
  `timescale 100 fs / 100 fs

`elsif GENERIC_PLL_TIMESCALE_1_PS
  `timescale 1 ps / 1 ps

`elsif GENERIC_PLL_TIMESCALE_10_PS
  `timescale 10 ps / 10 ps

`elsif GENERIC_PLL_TIMESCALE_100_PS
  `timescale 100 ps / 100 ps

`elsif GENERIC_PLL_TIMESCALE_1_NS
  `timescale 1 ns / 1 ns

`elsif GENERIC_PLL_TIMESCALE_10_NS
  `timescale 10 ns / 10 ns

`elsif GENERIC_PLL_TIMESCALE_100_NS
  `timescale 100 ns / 100 ns

`elsif GENERIC_PLL_TIMESCALE_1_US
  `timescale 1 us / 1 us

`elsif GENERIC_PLL_TIMESCALE_10_US
  `timescale 10 us / 10 us

`elsif GENERIC_PLL_TIMESCALE_100_US
  `timescale 100 us / 100 us

`elsif GENERIC_PLL_TIMESCALE_1_MS
  `timescale 1 ms / 1 ms

`elsif GENERIC_PLL_TIMESCALE_10_MS
  `timescale 10 ms / 10 ms

`elsif GENERIC_PLL_TIMESCALE_100_MS
  `timescale 100 ms / 100 ms

`elsif GENERIC_PLL_TIMESCALE_1_S
  `timescale 1 s / 1 s

`else
  `timescale 1 ps / 1 ps

`endif


package altera_generic_pll_functions;

	function real ABS (real num);
		ABS = (num <0) ? -num : num;
	endfunction // ABS 


	function logic is_refclk_out_of_range_abs;
		input real last_refclk_posedge;
		input real reference_clock_period_value;
		input real sim_pll_tolerance_for_refclk;

		real time_diff;
		logic result;
		begin
			result = 0;
			if ( last_refclk_posedge >= 0 )
				begin
					time_diff = $realtime - last_refclk_posedge;
					if ( ABS(time_diff - reference_clock_period_value) > sim_pll_tolerance_for_refclk )
						begin
							result = 1;
						end
				end
			is_refclk_out_of_range_abs = result;
		end
	endfunction



	function logic is_refclk_out_of_range;
		input real last_refclk_posedge;
		input real reference_clock_period_value;
		input real sim_pll_tolerance_for_refclk;

		real time_diff;
		logic result;
		begin
			result = 0;
			if ( last_refclk_posedge > 0 )
				begin
					time_diff = $realtime - last_refclk_posedge;
					if ( time_diff - reference_clock_period_value > sim_pll_tolerance_for_refclk )
						begin
							result = 1;
						end
				end
			is_refclk_out_of_range = result;
		end
	endfunction
	
	
	function real get_expected_value;
		// divided by 1000 because we are dealing khz
		// divided by another 1000 to avoid overflow 
		static real factor = 10**9;
		begin
			factor = 10**9;
			`ifdef GENERIC_PLL_TIMESCALE_1_FS
				factor = factor;

			`elsif GENERIC_PLL_TIMESCALE_10_FS
				factor = factor/10;

			`elsif GENERIC_PLL_TIMESCALE_100_FS
				factor = factor / 100;

			`elsif GENERIC_PLL_TIMESCALE_1_PS
				factor = factor / 1000;

			`elsif GENERIC_PLL_TIMESCALE_10_PS
				factor = factor / 10**4;

			`elsif GENERIC_PLL_TIMESCALE_100_PS
				factor = factor / 10**5;

			`elsif GENERIC_PLL_TIMESCALE_1_NS
				factor = factor / 10**6;

			`elsif GENERIC_PLL_TIMESCALE_10_NS
				factor = factor / 10**7;

			`elsif GENERIC_PLL_TIMESCALE_100_NS
				factor = factor / 10**8;

			`elsif GENERIC_PLL_TIMESCALE_1_US
				factor = factor / 10**9;

			`elsif GENERIC_PLL_TIMESCALE_10_US
				factor = factor / 10**10;

			`elsif GENERIC_PLL_TIMESCALE_100_US
				factor = factor / 10**11;

			`elsif GENERIC_PLL_TIMESCALE_1_MS
				factor = factor / 10**12;

			`elsif GENERIC_PLL_TIMESCALE_10_MS
				factor = factor / 10**13;

			`elsif GENERIC_PLL_TIMESCALE_100_MS
				factor = factor / 10**14;

			`elsif GENERIC_PLL_TIMESCALE_1_S
				factor = factor / 10**15;

			`else
				factor = factor / 10**3;

			`endif
			
			get_expected_value = factor;
		end
	endfunction
	
endpackage



module generic_pll
#(
	parameter lpm_type = "generic_pll",
	parameter duty_cycle =  50,
	parameter output_clock_frequency = "0 ps",
	parameter phase_shift = "0 ps",
	parameter reference_clock_frequency = "0 ps",
	parameter sim_additional_refclk_cycles_to_lock = 0,
	parameter fractional_vco_multiplier = "false",
	parameter use_khz = 1
) (
	input wire          refclk,
	input wire          rst,
	input wire          fbclk,
	input wire  [63:0]  writerefclkdata,
	input wire  [63:0]  writeoutclkdata,
	input wire  [63:0]  writephaseshiftdata,
	input wire  [63:0]  writedutycycledata,
	
	output wire         outclk,
	output wire         locked,
	output wire         fboutclk,
	output wire [63:0]  readrefclkdata,
	output wire [63:0]  readoutclkdata,
	output wire [63:0]  readphaseshiftdata,
	output wire [63:0]  readdutycycledata
);

	import altera_lnsim_functions::*;
	import altera_generic_pll_functions::*;

localparam sim_pll_tolerance_on_refclk_change = "10 ps";
localparam output_clock_as_period = is_period(output_clock_frequency);
localparam reference_clock_period_value_param = get_real_value(reference_clock_frequency);
localparam output_clock_period_value_param = get_real_value(output_clock_frequency);
localparam valid_pll_param = (reference_clock_period_value_param > 0)  && (output_clock_period_value_param > 0);

localparam allowed_drifting_param = "10 ps";

	real output_clock_high_period;
	real output_clock_low_period;
	real reference_clock_period_value;
	real output_clock_period_value;
	real adj_output_clock_period;
	real phase_shift_value;
	real duty_cycle_value;


	real last_refclk_posedge;
	real sim_pll_tolerance_for_refclk;
	
	real allowed_drifting;
	real n_subintervals;
	integer period_high;
	integer period_low;
	real period_diff_high;
	real period_diff_low;
	real nperiods_ceil_r, nperiods_floor_r;
	integer nperiods_ceil, nperiods_floor, remaining_periods;
	integer nperiods_ceil_orig, nperiods_floor_orig;
	real diff_before, diff_after;
	
	real output_clock_high_period_ceil, output_clock_high_period_floor, output_clock_low_period_ceil, output_clock_low_period_floor;
	real tmp_output_clock_high_period_ceil, tmp_output_clock_high_period_floor, 
			tmp_output_clock_low_period_ceil, tmp_output_clock_low_period_floor;
	reg changed_resolution;
	integer ii;
	
	integer long_period;
	integer short_period;

	reg outclk_reg;
	reg refclk_out_of_range;
	reg locked_reg;
	reg phase_shift_done_reg;
	integer refclk_cycles;
	logic unlock;

	// precision control
	logic ref_specified_as_period;
	logic out_specified_as_period;
	integer reference_clock_frequency_value;
	integer output_clock_frequency_value;
	integer common_freq;
	integer counter_N;
	integer counter_M;
	integer count_up_to_N;
	integer count_up_to_M;
	real checking_interval;
	logic sync;

	integer tolerance, min_tol, max_tol;
	reg done;

	real last_sync_event, time_since_last_sync_event;

	real last_refclk_period;
	integer stable_ref_clk_counter;
	
	reg msg_displayed;



generate
if ( valid_pll_param == 1 )
begin : no_need_to_gen
	initial
	begin
		tolerance = 0;
		min_tol = 0;
		max_tol = 0;
		done = 0;
		counter_N = -1;
		counter_M = -1;
		reference_clock_period_value = get_real_value(reference_clock_frequency);
		output_clock_period_value = get_real_value(output_clock_frequency);
		sim_pll_tolerance_for_refclk = get_real_value(sim_pll_tolerance_on_refclk_change);
		checking_interval = reference_clock_period_value * 0.5;
		
		allowed_drifting = get_real_value(allowed_drifting_param);

		if ( is_period(reference_clock_frequency) )
			ref_specified_as_period = 1;
		else
		begin
			ref_specified_as_period = 0;
			reference_clock_frequency_value = (use_khz) ? get_frequency_value_khz(reference_clock_frequency)
														: get_frequency_value(reference_clock_frequency);
		end

		if ( is_period(output_clock_frequency) )
			out_specified_as_period = 1;
		else
		begin
			out_specified_as_period = 0;
			output_clock_frequency_value = (use_khz) ? get_frequency_value_khz(output_clock_frequency)
													 : get_frequency_value(output_clock_frequency);
		end
		
		if (out_specified_as_period == 0 && ref_specified_as_period == 0 )
		begin
			tolerance = 0;
			done = 0;
			min_tol = 0;
			max_tol = 100;
			while ( !done )
			begin
				common_freq = gcd_with_tolerance(reference_clock_frequency_value,output_clock_frequency_value,tolerance);
				counter_N = rounded_division(reference_clock_frequency_value, common_freq);
				counter_M = rounded_division(output_clock_frequency_value, common_freq);

				// sanity check
				if ( counter_N > 512 || counter_M > 512 || counter_N < 0 || counter_M < 0 )
				begin
					done = 0;
					min_tol = tolerance;
					tolerance = (min_tol + max_tol) / 2;
					if ( tolerance == min_tol )
						tolerance = tolerance + 1;
					if (min_tol >= max_tol)
						done = 1;
					if ( counter_N > 0 && counter_M > 0 && fractional_vco_multiplier == "true" )
						done = 1;						
				end
				else
				begin
					if ( tolerance - min_tol < 2 || max_tol - min_tol < 2 )
					begin
						done = 1;
					end
					else
					begin
						max_tol = tolerance;
						tolerance = (min_tol + max_tol) / 2;
					end
				end
			end
		end
		else if (out_specified_as_period == 1)
		begin
			counter_N = 1000;
			counter_M = 1000;
		end
		else
		begin
			$display("Error: Output clock frequency is specified in Hz and reference clock in secs");
			$display("Please specify both either as frequencies or as time periods.");
			$finish;
		end


		// fix in period drifting due to precision error
		if ( out_specified_as_period == 0 && ref_specified_as_period == 0 )
		begin
			if ( (reference_clock_period_value/1000) * reference_clock_frequency_value == get_expected_value() )
			begin
				// perfect reference clock calculation
				// but output clock period is not good
				if (output_clock_period_value*counter_M != counter_N * reference_clock_period_value)
				begin
					adj_output_clock_period = counter_N * reference_clock_period_value / counter_M;
					if ( iabs( output_clock_period_value*counter_M - counter_N * reference_clock_period_value ) 
						> iabs( adj_output_clock_period*counter_M - counter_N * reference_clock_period_value ) )
					begin
						// adjust to reference clock
						$display("Adjusting output period from %f to %f",output_clock_period_value,adj_output_clock_period);
						output_clock_period_value = adj_output_clock_period;
					end
				end
			end
		end


		count_up_to_N = 0;
		count_up_to_M = 0;
		sync = 0;
		
        phase_shift_value = get_phase_shift_value(phase_shift, output_clock_frequency);
		duty_cycle_value = duty_cycle / 100.0;
		output_clock_high_period = output_clock_period_value * duty_cycle_value;
		output_clock_low_period = output_clock_period_value * (1.0 - duty_cycle_value);

		changed_resolution = 1'b0;
		// at this point we have as good as an output_clock_period as it can get
		// but is not good enough when the condition below holds
		if ( 2*allowed_drifting < counter_M && allowed_drifting > 1)
		begin
			// at least 2 intervals
			// n_subintervals = counter_M / allowed_drifting - 1;
			n_subintervals = allowed_drifting;
			period_high = output_clock_high_period;
			period_diff_high = output_clock_high_period - period_high;
			period_low = output_clock_low_period;
			period_diff_low = output_clock_low_period - period_low;
			output_clock_high_period_ceil = output_clock_high_period;
			output_clock_high_period_floor = output_clock_high_period;
			output_clock_low_period_ceil = output_clock_low_period;
			output_clock_low_period_floor = output_clock_low_period;
			// only do something when values have been truncated
			// and when we have 50% duty cycle
			// if (period_diff_low > 0 && period_diff_high > 0 && output_clock_high_period == output_clock_low_period)
			nperiods_floor_orig = 0;
			nperiods_ceil_orig = 0;
			if ( output_clock_high_period == output_clock_low_period && period_diff_low == period_diff_high && 
				period_diff_high != 0 )
			begin
				nperiods_floor = 0;
				nperiods_ceil = 0;
				nperiods_floor_orig = 0;
				nperiods_ceil_orig = 0;
				if (period_diff_low > 0)
				begin
					// we truncated
					long_period = period_high + period_low+2;
					short_period = period_high + period_low;
					nperiods_ceil_r = period_diff_high * n_subintervals;
					nperiods_ceil = $rtoi(nperiods_ceil_r);
					nperiods_floor = n_subintervals - nperiods_ceil;
					tmp_output_clock_high_period_ceil = period_high +1;
					tmp_output_clock_high_period_floor = period_high;
					tmp_output_clock_low_period_ceil = period_low + 1;
					tmp_output_clock_low_period_floor = period_low;
					
				end
				else
				begin
					// we rounded up
					long_period = period_high + period_low;
					short_period = period_high + period_low-2;
					nperiods_floor_r = (-period_diff_high) * n_subintervals;
					//nperiods_floor = $rtoi(nperiods_floor_r);
					nperiods_floor = nperiods_floor_r;
					nperiods_ceil = n_subintervals - nperiods_floor;
					tmp_output_clock_high_period_ceil = period_high;
					tmp_output_clock_high_period_floor = period_high - 1;
					tmp_output_clock_low_period_ceil = period_low;
					tmp_output_clock_low_period_floor = period_low - 1;
				end
				//nperiods_ceil = period_diff_high * n_subintervals;
				//nperiods_floor = n_subintervals - nperiods_ceil;
				remaining_periods = counter_M - allowed_drifting * ( nperiods_ceil+nperiods_floor);
				diff_before = abs(counter_M *(period_high + period_low) - counter_N * reference_clock_period_value);
				diff_after = abs( nperiods_ceil*long_period*allowed_drifting + nperiods_floor*short_period*allowed_drifting + remaining_periods*(period_high + period_low) 
									- counter_N * reference_clock_period_value);
				// sanity check
				if (diff_before >= diff_after || diff_before > allowed_drifting)
				begin
					output_clock_high_period_ceil = tmp_output_clock_high_period_ceil;
					output_clock_high_period_floor = tmp_output_clock_high_period_floor;
					output_clock_low_period_ceil = tmp_output_clock_low_period_ceil;
					output_clock_low_period_floor = tmp_output_clock_low_period_floor;
					nperiods_floor_orig = nperiods_floor;
					nperiods_ceil_orig = nperiods_ceil;
					changed_resolution = 1'b1;
				end
				
			end
			
		end


		outclk_reg = 1'bX;
		locked_reg = 0;
		phase_shift_done_reg = 0;
		refclk_cycles = 0;
		last_refclk_posedge = -1;
		refclk_out_of_range = 0;
		
		last_refclk_period = -1;
		stable_ref_clk_counter = 0;
		
		msg_displayed = 1'b0;

		$display("Info: =================================================");
		$display("Info:           Generic PLL Summary");
		$display("Info: =================================================");
		$printtimescale;
		$display("Info: hierarchical_name = %m");
		$display("Info: reference_clock_frequency = %0s", reference_clock_frequency);
		$display("Info: output_clock_frequency = %0s", output_clock_frequency);
		$display("Info: phase_shift = %0s", phase_shift);
		$display("Info: duty_cycle = %0d", duty_cycle);
		$display("Info: sim_additional_refclk_cycles_to_lock = %0d", sim_additional_refclk_cycles_to_lock);
		$display("Info: output_clock_high_period = %0f", output_clock_high_period);
		$display("Info: output_clock_low_period = %0f", output_clock_low_period);
	end


	///////////////////////////////////////////////////////////
	// Checks to monitor that refclk is out of specified range
	//////////////////////////////////////////////////////////

	// 1. Check based on the refclk - This is also needed because it maintains the last_refclk_posedge
	always @(posedge refclk)
		begin
			if ( locked )
				if ( is_refclk_out_of_range_abs(last_refclk_posedge, reference_clock_period_value, sim_pll_tolerance_for_refclk) )
				begin
					refclk_out_of_range <= 1;
				end
			last_refclk_posedge <= $realtime;
		end



	// 2. Check based on any event on sync or outclk_reg.
	// This is needed because there could be no events on refclk
	always @(outclk_reg or sync)
		begin
			if ( locked )
				if ( is_refclk_out_of_range(last_refclk_posedge, reference_clock_period_value, sim_pll_tolerance_for_refclk) )
				begin
					refclk_out_of_range <= 1;
				end
		end


	// 3. Check at regular intervals whose length depend on the refclk period.
	// All previous signals checked could be DC.
	always
		begin
			wait (locked == 1);
			#checking_interval;
			if ( is_refclk_out_of_range(last_refclk_posedge, reference_clock_period_value, sim_pll_tolerance_for_refclk) )
			begin
				refclk_out_of_range <= 1;
			end
		end



	///////////////////////////////////////////////////////////
	// The PLL should be unlocked when rst is one or when refclk is out of range
	//////////////////////////////////////////////////////////
	assign unlock = rst | refclk_out_of_range;


	///////////////////////////////////////////////////////////
	// Locking sequence
	//////////////////////////////////////////////////////////
	always @(posedge refclk or posedge unlock)
		begin
			if (unlock)
				begin
					refclk_cycles <= 0;
					phase_shift_done_reg <= 0;
					locked_reg <= 0;
					outclk_reg <= 1'bX;
					refclk_out_of_range <= 1'b0;
				end
			else if (refclk_cycles < sim_additional_refclk_cycles_to_lock)
				refclk_cycles <= refclk_cycles + 1;
			else if ( locked_reg == 0 )
				begin
					count_up_to_N <= 0;
					count_up_to_M <= 0;
					outclk_reg <= 0;
					locked_reg <= 1;
				end
		 end

end
endgenerate


generate
if (valid_pll_param == 1 && output_clock_as_period == 0 )
begin : UI
	always @(posedge refclk_out_of_range)
	begin
		if ( !msg_displayed )
		begin
			$display("Warning: The frequency of the reference clock signal differs from the specified frequency.");
			msg_displayed <= 1'b1;
		end
	end
end
endgenerate



	generate
	if (valid_pll_param == 1 && output_clock_as_period == 0 )
	begin : adjustment_to_variable_ref_clk
	always @(posedge refclk)
		begin
			if ( is_refclk_out_of_range_abs(last_refclk_posedge, reference_clock_period_value, sim_pll_tolerance_for_refclk) )
			begin
				if (last_refclk_period == ($realtime - last_refclk_posedge) )
				begin
					stable_ref_clk_counter <= stable_ref_clk_counter + 1;
					if ( stable_ref_clk_counter > 4 )
					begin
						output_clock_period_value <= last_refclk_period * counter_N / counter_M;
						output_clock_high_period <= (last_refclk_period * counter_N / counter_M) * duty_cycle_value;
						output_clock_low_period <= (last_refclk_period * counter_N / counter_M) * (1.0 - duty_cycle_value);
						reference_clock_period_value <= last_refclk_period;
					end
				end
				else
				begin
					stable_ref_clk_counter <= 0;
					last_refclk_period <= ($realtime - last_refclk_posedge);
				end
			end
			else
			begin
				stable_ref_clk_counter <= 0;
			end
		end
	end
	endgenerate





	///////////////////////////////////////////////////////////
	// Produce sync signal to sync refclk and outclk at regular intervals
	//////////////////////////////////////////////////////////
	// The sync signal is used to synchronize the clocks and prevent clock drifting.
	// The output clock syncs to the refclk after N refclk cycles.
	// This is only needed if the output clock is expressed as a frequency value.
	generate
	if (valid_pll_param == 1 && output_clock_as_period == 0 )
	begin : sync_signal_generation
	always @(posedge refclk)
		begin
			sync <= 0;
			if ( locked_reg == 1)
			begin
				if ( count_up_to_N + 1 == counter_N )
				begin
					count_up_to_N <= 0;
					// #phase_shift_value sync <= 1;
					sync <= #phase_shift_value 1;
				end
				else
					count_up_to_N <= count_up_to_N + 1;
			end
		end


	always @(negedge refclk)
		begin
			if ( counter_N == 1 )
				sync <= #phase_shift_value 0;
		end
	end
	endgenerate


	///////////////////////////////////////////////////////////
	// Produce output clock after locked_reg goes to 1
	//////////////////////////////////////////////////////////
	// This is only needed if the output clock is expressed as a frequency value.
	generate
	if (valid_pll_param == 1 && output_clock_as_period == 0 )
	begin : first_cycles_if_sync
	// The first (after locked_reg='1') M cycles of the outclk are produced.
	always @(posedge locked_reg)
		begin
			outclk_reg = 0;
			#phase_shift_value outclk_reg = 1;
			phase_shift_done_reg = 1;
			#output_clock_high_period outclk_reg = 0;
			if ( changed_resolution == 1'b0 )
			begin
				for (count_up_to_M = 0; count_up_to_M < counter_M-1; count_up_to_M = count_up_to_M + 1)
					begin
						#output_clock_low_period outclk_reg = 1;
						#output_clock_high_period outclk_reg = 0;
					end
			end
			else
			begin
				// schedule
				if (locked_reg == 1'b1)
				begin
	`ifndef GENERIC_PLL_FAST_MODEL
					last_sync_event = $realtime;
	`endif
					for (count_up_to_M = 0; count_up_to_M + n_subintervals < counter_M - 1; count_up_to_M = count_up_to_M + n_subintervals)
					begin
						if (locked_reg == 1'b1)
						begin
							for (ii = 0; ii < nperiods_floor; ii = ii + 1)
							begin
								#output_clock_low_period_floor outclk_reg = 1;
								#output_clock_high_period_floor  outclk_reg = 0;
							end
							for (ii = 0; ii < nperiods_ceil; ii = ii + 1)
							begin
								#output_clock_low_period_ceil outclk_reg = 1;
								#output_clock_high_period_ceil  outclk_reg = 0;
							end
		`ifndef GENERIC_PLL_FAST_MODEL
							time_since_last_sync_event = $realtime - last_sync_event;
							if ( abs( time_since_last_sync_event - ( count_up_to_M + n_subintervals ) * output_clock_period_value) > 1 )
							begin
								if ( time_since_last_sync_event - ( count_up_to_M + n_subintervals ) * output_clock_period_value > 1  )
								begin
									nperiods_floor = (nperiods_ceil > 0 ) ? ( ( nperiods_ceil > nperiods_ceil_orig ) ? 	nperiods_floor_orig : 
																														nperiods_floor + 1 ) : 
																			nperiods_floor;
									nperiods_ceil = (nperiods_ceil > 0 ) ? ( ( nperiods_ceil > nperiods_ceil_orig) ? 	nperiods_ceil_orig :
																														nperiods_ceil - 1 ) : 
																			nperiods_ceil;
								end
								else
								begin
									nperiods_ceil = (nperiods_floor > 0)	? ( ( nperiods_floor > nperiods_floor_orig )? nperiods_ceil_orig 
																														: nperiods_ceil + 1 )
																			: nperiods_ceil;
									nperiods_floor = (nperiods_floor > 0)	? ( ( nperiods_floor > nperiods_floor_orig )? nperiods_floor_orig 
																														: nperiods_floor - 1 )
																			: nperiods_floor;
								end
							end
		`endif
						end
						else begin
							ii = 0;
						end
					end

					// remaining
					for (count_up_to_M = count_up_to_M; count_up_to_M < counter_M - 1; count_up_to_M = count_up_to_M + 1)
					begin
						#output_clock_low_period outclk_reg = 1;
						#output_clock_high_period  outclk_reg = 0;
					end
				end
				else
				begin
					outclk_reg = 0;
				end
			end

		end
	end
	else if ( valid_pll_param == 1 )
	begin
		always @(posedge locked_reg)
			begin
				outclk_reg = 0;
				#phase_shift_value outclk_reg = 1;
				phase_shift_done_reg = 1;
			end
	end
	endgenerate
    
	///////////////////////////////////////////////////////////
	// Produce output clock based on sync
	//////////////////////////////////////////////////////////
	generate
	if (valid_pll_param == 1 && output_clock_as_period == 0 )
	begin : cycles_with_sync
	// Synchronize to the refclk every M cycles of the output clock.
	always @(posedge sync)
		begin
`ifndef GENERIC_PLL_FAST_MODEL
			last_sync_event = $realtime;
`endif
			if (phase_shift_done_reg == 1)
        		begin
					outclk_reg = 1;
					if (changed_resolution == 1'b1)
					begin
						// schedule
						for (count_up_to_M = 0; count_up_to_M + n_subintervals < counter_M - 1; count_up_to_M = count_up_to_M + n_subintervals)
							begin
								for (ii = 0; ii < nperiods_floor; ii = ii + 1)
								begin
									#output_clock_high_period_floor outclk_reg = 0;
									#output_clock_low_period_floor  outclk_reg = 1;
								end
								for (ii = 0; ii < nperiods_ceil; ii = ii + 1)
								begin
									#output_clock_high_period_ceil outclk_reg = 0;
									#output_clock_low_period_ceil  outclk_reg = 1;
								end
`ifndef GENERIC_PLL_FAST_MODEL
								time_since_last_sync_event = $realtime - last_sync_event;
								if ( abs( time_since_last_sync_event - ( count_up_to_M + n_subintervals ) * output_clock_period_value) > 1 )
								begin
									if ( time_since_last_sync_event - ( count_up_to_M + n_subintervals ) * output_clock_period_value > 1  )
									begin
										// output is slower, so speed up
										nperiods_floor = (nperiods_ceil > 0 ) ? ( ( nperiods_ceil > nperiods_ceil_orig ) ? 	nperiods_floor_orig : 
																															nperiods_floor + 1 ) : 
																				nperiods_floor;
										nperiods_ceil = (nperiods_ceil > 0 ) ? ( ( nperiods_ceil > nperiods_ceil_orig) ? 	nperiods_ceil_orig :
																															nperiods_ceil - 1 ) : 
																				nperiods_ceil;
									end
									else
									begin
										// output is faster, so slow down
										nperiods_ceil = (nperiods_floor > 0)	? ( ( nperiods_floor > nperiods_floor_orig )? nperiods_ceil_orig 
																															: nperiods_ceil + 1 )
																				: nperiods_ceil;
										nperiods_floor = (nperiods_floor > 0)	? ( ( nperiods_floor > nperiods_floor_orig )? nperiods_floor_orig 
																															: nperiods_floor - 1 )
																				: nperiods_floor;
									end
								end
`endif
							end
						// remaining
						for (count_up_to_M = count_up_to_M; count_up_to_M < counter_M - 1; count_up_to_M = count_up_to_M + 1)
							begin
								#output_clock_high_period outclk_reg = 0;
								#output_clock_low_period  outclk_reg = 1;
							end
						#output_clock_high_period outclk_reg = 0;
        			end
					else
					begin
						for (count_up_to_M = 0; count_up_to_M < counter_M - 1; count_up_to_M = count_up_to_M + 1)
							begin
								#output_clock_high_period outclk_reg = 0;
								#output_clock_low_period  outclk_reg = 1;
							end
						#output_clock_high_period outclk_reg = 0;
					end
				end
		end
	end
	else if ( valid_pll_param == 1 )
	begin
		always
		begin
			wait (phase_shift_done_reg == 1)
			begin
				#output_clock_high_period outclk_reg = 0;
				#output_clock_low_period outclk_reg = 1;
			end
	end

	end
	endgenerate


	///////////////////////////////////////////////////////////
	// Produce outputs: if the locked signal is 1, the output will be 0.
	//////////////////////////////////////////////////////////
	assign outclk = (locked) ? outclk_reg : 1'b0;
	assign locked = locked_reg;
	assign fboutclk = refclk && locked;


	// TODO - Temporarily driving AVMM adapter outputs to zero
	assign  readrefclkdata      = 64'd0;
	assign  readoutclkdata      = 64'd0;
	assign  readphaseshiftdata  = 64'd0;
	assign  readdutycycledata   = 64'd0;

endmodule

`timescale 1 ps/1 ps
module generic_cdr
#(
	parameter reference_clock_frequency = "0 ps",
	parameter output_clock_frequency = "0 ps",
	parameter sim_debug_msg = "false"
) (
	input wire extclk,
	input wire ltd,
	input wire ltr,
	input wire pciel,
	input wire pciem,
	input wire ppmlock,
	input wire refclk,
	input wire rst,
	input wire sd,
	input wire rxp,

	output wire clk90bdes,
	output wire clk270bdes,
	output wire clklow,
	output reg deven,
	output reg dodd,
	output wire fref,
	output wire pfdmodelock,
	output wire rxplllock
);

	import altera_lnsim_functions::*;

	wire clk0_wire;
	wire clk0_pcie_00_wire;
	wire clk0_pcie_01_wire;
	wire clk0_pcie_11_wire;
	wire clk90_wire;
	wire clk90_pcie_00_wire;
	wire clk90_pcie_01_wire;
	wire clk90_pcie_11_wire;
	wire clk180_wire;
	wire clk270_wire;
	wire datain_ipd;
	wire datain_dly;
	reg deven_int1_reg;
	reg deven_int2_reg;
	reg dodd_int1_reg;
	reg dodd_int2_reg;
	wire fboutclk_wire;
	wire lck2ref_wire;
	wire locked_wire;

	initial
	begin
		deven <= 1'b1;
		dodd <= 1'b1;
		deven_int1_reg = 1'b0;
		dodd_int1_reg = 1'b0;
		deven_int2_reg = 1'b0;
		dodd_int2_reg = 1'b0;
		$display("Info: =================================================");
		$display("Info:           Generic CDR Summary");
		$display("Info: =================================================");
		$printtimescale;
		$display("Info: hierarchical_name = %m");
		$display("Info: reference_clock_frequency = %0s", reference_clock_frequency);
		$display("Info: output_clock_frequency = %0s", output_clock_frequency);
	end

	//////////////////////////////////////////////////
	// clk0
	//////////////////////////////////////////////////
        // For PCIe, clk0_pcie_00_wire -> Gen2 speed (pcie_sw[1:0]=01, {pciem,pciel} = 2'b00)
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift("0 ps")
	) inst_cdr_clk0_pcie_00 (
		.refclk(refclk),
		.rst(rst),
		.fbclk(fboutclk_wire),
		
		.outclk(clk0_pcie_00_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	);

        // For PCIe, clk0_pcie_01_wire -> Gen1 speed (pcie_sw[1:0]=00, {pciem,pciel} = 2'b01)
        // Only generate for PCIe allowed ref clk frequencies
	generate
          if (reference_clock_frequency == "100 MHz" || reference_clock_frequency == "100 mhz" || reference_clock_frequency == "100.0 MHz" || reference_clock_frequency == "100.0 mhz" ||
              reference_clock_frequency == "125 MHz" || reference_clock_frequency == "125 mhz" || reference_clock_frequency == "125.0 MHz" || reference_clock_frequency == "125.0 mhz")         
          begin : LABEL_ME0
            generic_pll
	    #(
	    	.reference_clock_frequency(reference_clock_frequency),
	    	.output_clock_frequency(get_time_string(get_time_value(output_clock_frequency) * 2, "ps")),
	    	.phase_shift("0 ps")
	    ) inst_cdr_clk0_pcie_01 (
	    	.refclk(refclk),
	    	.rst(rst),
	    	.fbclk(fboutclk_wire),
	    	
	    	.outclk(clk0_pcie_01_wire),
	    	.locked(),
	    	.fboutclk(),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	    );
          end 
          else
            assign clk0_pcie_01_wire = 1'bx;
        endgenerate

	// For PCIe, clk0_pcie_11_wire -> Gen3 speed (pcie_sw[1:0]=10, {pciem,pciel} = 2'b11)
        // Use this PLL to always create Gen3 speed clock: output_clock_frequency=4G)
        // Only generate for PCIe allowed ref clk frequencies
        generate
          if (reference_clock_frequency == "100 MHz" || reference_clock_frequency == "100 mhz" || reference_clock_frequency == "100.0 MHz" || reference_clock_frequency == "100.0 mhz" ||
              reference_clock_frequency == "125 MHz" || reference_clock_frequency == "125 mhz" || reference_clock_frequency == "125.0 MHz" || reference_clock_frequency == "125.0 mhz")         
          begin : LABEL_ME1
	    generic_pll
	    #(
	    	.reference_clock_frequency(reference_clock_frequency),
	    	.output_clock_frequency("4000.000000 MHz"),
	    	.phase_shift("0 ps")
	    ) inst_cdr_clk0_pcie_11 (
	    	.refclk(refclk),
	    	.rst(rst),
	    	.fbclk(fboutclk_wire),
	    	
	    	.outclk(clk0_pcie_11_wire),
	    	.locked(),
	    	.fboutclk(),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	    );
          end 
          else
            assign clk0_pcie_11_wire = 1'bx;
        endgenerate

	assign clk0_wire = {pciem, pciel} == 2'b00 ? clk0_pcie_00_wire :
					   {pciem, pciel} == 2'b01 ? clk0_pcie_01_wire :
					   {pciem, pciel} == 2'b11 ? clk0_pcie_11_wire :
					   1'bx;
	
	//////////////////////////////////////////////////
	// clk90
	//////////////////////////////////////////////////
        // For PCIe, clk90_pcie_00_wire -> Gen2 speed (pcie_sw[1:0]=01, {pciem,pciel} = 2'b00)
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(get_time_string(get_time_value(output_clock_frequency) / 4, "ps"))
	) inst_cdr_clk90_pcie_00 (
		.refclk(refclk),
		.rst(rst),
		.fbclk(fboutclk_wire),
		
		.outclk(clk90_pcie_00_wire),
		.locked(),
		.fboutclk(),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	);

        // For PCIe, clk90_pcie_01_wire -> Gen1 speed (pcie_sw[1:0]=00, {pciem,pciel} = 2'b01)
	// Only generate for PCIe allowed ref clk frequencies
	generate
          if (reference_clock_frequency == "100 MHz" || reference_clock_frequency == "100 mhz" || reference_clock_frequency == "100.0 MHz" || reference_clock_frequency == "100.0 mhz" ||
              reference_clock_frequency == "125 MHz" || reference_clock_frequency == "125 mhz" || reference_clock_frequency == "125.0 MHz" || reference_clock_frequency == "125.0 mhz")         
          begin : LABEL_ME2
            generic_pll
	    #(
	    	.reference_clock_frequency(reference_clock_frequency),
	    	.output_clock_frequency(get_time_string(get_time_value(output_clock_frequency) * 2, "ps")),
	    	.phase_shift(get_time_string(get_time_value(output_clock_frequency) * 2 / 4, "ps"))
	    ) inst_cdr_clk90_pcie_01 (
	    	.refclk(refclk),
	    	.rst(rst),
	    	.fbclk(fboutclk_wire),
	    	
	    	.outclk(clk90_pcie_01_wire),
	    	.locked(),
	    	.fboutclk(),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	    );
          end 
          else
            assign clk90_pcie_01_wire = 1'bx;
        endgenerate

	// For PCIe, clk90_pcie_11_wire -> Gen3 speed (pcie_sw[1:0]=10, {pciem,pciel} = 2'b11)
        // Use this PLL to always create Gen3 speed clock: output_clock_frequency=4G)
	// Only generate for PCIe allowed ref clk frequencies
        generate
          if (reference_clock_frequency == "100 MHz" || reference_clock_frequency == "100 mhz" || reference_clock_frequency == "100.0 MHz" || reference_clock_frequency == "100.0 mhz" ||
              reference_clock_frequency == "125 MHz" || reference_clock_frequency == "125 mhz" || reference_clock_frequency == "125.0 MHz" || reference_clock_frequency == "125.0 mhz")         
          begin : LABEL_ME3
            generic_pll
	    #(
	    	.reference_clock_frequency(reference_clock_frequency),
	    	.output_clock_frequency("4000.000000 MHz"),
	    	.phase_shift(get_time_string(get_time_value("4000.000000 MHz") / 4, "ps"))
	    ) inst_cdr_clk90_pcie_11 (
	    	.refclk(refclk),
	    	.rst(rst),
	    	.fbclk(fboutclk_wire),
	    	
	    	.outclk(clk90_pcie_11_wire),
	    	.locked(),
	    	.fboutclk(),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	    );
          end 
          else
            assign clk90_pcie_11_wire = 1'bx;
        endgenerate


        assign clk90_wire = {pciem, pciel} == 2'b00 ? clk90_pcie_00_wire :
						{pciem, pciel} == 2'b01 ? clk90_pcie_01_wire :
						{pciem, pciel} == 2'b11 ? clk90_pcie_11_wire :
						1'bx;

	//////////////////////////////////////////////////
	// clk180
	//////////////////////////////////////////////////
	assign clk180_wire = !clk0_wire;
	
	//////////////////////////////////////////////////
	// clk270
	//////////////////////////////////////////////////
	assign clk270_wire = !clk90_wire;

	//////////////////////////////////////////////////
	// clk90bdes
	//////////////////////////////////////////////////
	assign clk90bdes = clk90_wire;

	//////////////////////////////////////////////////
	// clk270bdes
	//////////////////////////////////////////////////
	assign clk270bdes = clk270_wire;
	
	//////////////////////////////////////////////////
	// clklow
	//////////////////////////////////////////////////
	assign clklow = fboutclk_wire && !rst;

	//////////////////////////////////////////////////
	// deven and dodd
	//////////////////////////////////////////////////
	assign datain_ipd = (rxp === 1'b1) ? 1'b1 : 1'b0;
	assign #5 datain_dly = datain_ipd;
	
	always @ (clk0_wire)
		if (clk0_wire == 1'b1)
			deven_int1_reg <= datain_dly;
		else if (clk0_wire == 1'b0)
			deven_int2_reg <= deven_int1_reg;

	always @ (clk180_wire)
		if (clk180_wire == 1'b1)
			dodd_int1_reg <= datain_dly;
		else if (clk180_wire == 1'b0)
			dodd_int2_reg <= dodd_int1_reg;

	always @ (posedge clk90_wire)
		{deven ,dodd} <= {deven_int2_reg, dodd_int2_reg};

	//////////////////////////////////////////////////
	// fref
	//////////////////////////////////////////////////
	assign fref = refclk;
	
	//////////////////////////////////////////////////
	// pciel, pciem, and rst
	//////////////////////////////////////////////////
	generate
		if (sim_debug_msg == "true")
			always @(ltd or ltr or pciel or pciem or ppmlock or rst or sd) 
				begin
					$display("Info: =================================================");
					$display("Info:           Generic CDR at time %0d", $time);
					$display("Info: =================================================");
					$display("Info: hierarchical_name = %m");
					$display("Info: ltd = %v ", ltd);
					$display("Info: ltr = %v ", ltr);
					$display("Info: pciel = %v", pciel);
					$display("Info: pciem = %v", pciem);
					$display("Info: ppmlock = %v", ppmlock);
					$display("Info: rst = %v ", rst);
					$display("Info: sd = %v", sd);
				end
	endgenerate

	//////////////////////////////////////////////////
	// pfdmodelock
	//////////////////////////////////////////////////
	assign pfdmodelock = locked_wire && ~rst;
	
	//////////////////////////////////////////////////
	// rxplllock
	//////////////////////////////////////////////////
	assign lck2ref_wire = ltd ? 1'b0 :
						 (~sd | ~ppmlock | ltr ) ? 1'b1 : 
						 (sd & ppmlock & ~ltr & ~pfdmodelock ) ? 1'b1 :
						 (sd & ppmlock & ~ltr &  pfdmodelock ) ? 1'b0 :
						 1'b0;
	assign rxplllock = !lck2ref_wire;

endmodule


`timescale 1 ps/1 ps

// Deactivate the LEDA rule that requires uppercase letters for all
// parameter names
// leda rule_G_521_3_B off


//--------------------------------------------------------------------------
// Module Name     : common_28nm_ram_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------

module common_28nm_ram_pulse_generator (
                                    clk,
                                    ena,
                                    pulse,
                                    cycle
                                   );
input  clk;   // clock
input  ena;   // pulse enable
output pulse; // pulse
output cycle; // delayed clock

parameter delay_pulse = 1'b0;
parameter start_delay = (delay_pulse == 1'b0) ? 1 : 2; // delay write
reg  state;
reg  clk_prev;
wire clk_ipd;

specify
    specparam t_decode = 0,t_access = 0;
    (posedge clk => (pulse +: state)) = (t_decode,t_access);
endspecify

buf #(start_delay) (clk_ipd,clk);

initial clk_prev = 1'bx;

always @(clk_ipd or posedge pulse)
begin
    if      (pulse) state <= 1'b0;
    else if (ena && clk_ipd === 1'b1 && clk_prev === 1'b0)   state <= 1'b1;
  clk_prev = clk_ipd;
end

assign cycle = clk_ipd;
assign pulse = state; 

endmodule

//--------------------------------------------------------------------------
// Module Name     : common_28nm_ram_register
// Description     : Register module for RAM inputs/outputs
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module common_28nm_ram_register (
                             d,
                             clk,
                             aclr,
                             devclrn,
                             devpor,
                             stall,
                             ena,
                             q,
                             aclrout
                            );

parameter width = 1;      // data width
parameter preset = 1'b0;  // clear acts as preset

input [width - 1:0] d;    // data
input clk;                // clock
input aclr;               // asynch clear
input devclrn,devpor;     // device wide clear/reset
input stall; // address stall
input ena;                // clock enable
output [width - 1:0] q;   // register output
output aclrout;           // delayed asynch clear

wire ena_ipd = ena;
wire clk_ipd = clk;
wire aclr_ipd = aclr;
wire [width - 1:0] d_ipd = d;
wire stall_ipd = stall;
wire  [width - 1:0] q_opd;

reg   [width - 1:0] q_reg;
reg viol_notifier;
wire reset;

assign reset = devpor && devclrn && (!aclr_ipd) && (ena_ipd);
specify
      $setup  (d,    posedge clk &&& reset, 0, viol_notifier);
      $setup  (aclr, posedge clk, 0, viol_notifier);
      $setup  (ena,  posedge clk &&& reset, 0, viol_notifier );
      $setup  (stall, posedge clk &&& reset, 0, viol_notifier );
      $hold   (posedge clk &&& reset, d   , 0, viol_notifier);
      $hold   (posedge clk, aclr, 0, viol_notifier);
      $hold   (posedge clk &&& reset, ena , 0, viol_notifier );
      $hold   (posedge clk &&& reset, stall, 0, viol_notifier );
      (posedge clk =>  (q +: q_reg)) = (0,0);
      (posedge aclr => (q +: q_reg)) = (0,0);
endspecify

initial q_reg <= (preset) ? {width{1'b1}} : 'b0;

always @(posedge clk_ipd or posedge aclr_ipd or negedge devclrn or negedge devpor)
begin
    if (aclr_ipd || ~devclrn || ~devpor)
        q_reg <= (preset) ? {width{1'b1}} : 'b0;
        else if (ena_ipd & !stall_ipd)
        q_reg <= d_ipd;
end
assign aclrout = aclr_ipd;

assign q = q_reg; 

endmodule

`timescale 1 ps/1 ps

`define PRIME 1
`define SEC   0

//--------------------------------------------------------------------------
// Module Name     : common_28nm_ram_block
// Description     : Main RAM module
//--------------------------------------------------------------------------

module common_28nm_ram_block
    (
     portadatain,
     portaaddr,
     portawe,
     portare,
     portbdatain,
     portbaddr,
     portbwe,
     portbre,
     clk0, clk1,
     ena0, ena1,
     ena2, ena3,
     clr0, clr1,
     nerror,
     portabyteenamasks,
     portbbyteenamasks,
     portaaddrstall,
     portbaddrstall,
     devclrn,
     devpor,
     eccstatus,
     portadataout,
     portbdataout
     );

// -------- PACKAGES ------------------

import altera_lnsim_functions::*;

// -------- GLOBAL PARAMETERS ---------
parameter operation_mode = "single_port";
parameter mixed_port_feed_through_mode = "dont_care";

parameter init_file_layout = "none";

parameter ecc_pipeline_stage_enabled = "false";
parameter enable_ecc = "false";
parameter width_eccstatus = 2;
parameter port_a_first_address = 0;
parameter port_a_last_address = 0;

parameter port_a_data_out_clear = "none";
parameter port_a_data_out_clock = "none";

parameter port_a_data_width = 1;
parameter port_a_address_width = 1;
parameter port_a_byte_enable_mask_width = 1;

parameter port_b_first_address = 0;
parameter port_b_last_address = 0;

parameter port_b_address_clear = "none";
parameter port_b_data_out_clear = "none";

parameter port_b_data_in_clock = "clock1";
parameter port_b_address_clock = "clock1";
parameter port_b_write_enable_clock = "clock1";
parameter port_b_read_enable_clock  = "clock1";
parameter port_b_byte_enable_clock = "clock1";
parameter port_b_data_out_clock = "none";

parameter port_b_data_width = 1;
parameter port_b_address_width = 1;
parameter port_b_byte_enable_mask_width = 1;

parameter power_up_uninitialized = "false";

parameter mem_init0 = "";
parameter mem_init1 = "";
parameter mem_init2 = "";
parameter mem_init3 = "";
parameter mem_init4 = "";
parameter mem_init5 = "";
parameter mem_init6 = "";
parameter mem_init7 = "";
parameter mem_init8 = "";
parameter mem_init9 = "";

parameter clk0_input_clock_enable  = "none"; // ena0,ena2,none
parameter clk0_core_clock_enable   = "none"; // ena0,ena2,none
parameter clk0_output_clock_enable = "none"; // ena0,none
parameter clk1_input_clock_enable  = "none"; // ena1,ena3,none
parameter clk1_core_clock_enable   = "none"; // ena1,ena3,none
parameter clk1_output_clock_enable = "none"; // ena1,none

parameter bist_ena = "false"; //false, true 

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter port_a_address_clear = "none";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_read_enable_clock = "clock0";

// SIMULATION_ONLY_PARAMETERS_END

// LOCAL_PARAMETERS_BEGIN

parameter primary_port_is_a  = (port_b_data_width <= port_a_data_width) ? 1'b1 : 1'b0;
parameter primary_port_is_b  = ~primary_port_is_a;

parameter mode_is_dp  = (operation_mode == "dual_port") ? 1'b1 : 1'b0;
parameter mode_is_sp  = (operation_mode == "single_port") ? 1'b1 : 1'b0;
parameter mode_is_rom = (operation_mode == "rom") ? 1'b1 : 1'b0;
parameter mode_is_bdp = (operation_mode == "bidir_dual_port") ? 1'b1 : 1'b0;
parameter mode_is_rom_or_sp  = (mode_is_rom || mode_is_sp) ? 1'b1 : 1'b0;

parameter mixed_port_rdw_is_dont_care = (mixed_port_feed_through_mode == "dont_care") ? 1'b1 : 1'b0;

parameter out_a_is_reg = (port_a_data_out_clock == "none") ? 1'b0 : 1'b1;
parameter out_b_is_reg = (port_b_data_out_clock == "none") ? 1'b0 : 1'b1;

parameter data_width         = (primary_port_is_a) ? port_a_data_width : port_b_data_width;
parameter data_unit_width    = (mode_is_rom_or_sp | primary_port_is_b) ? port_a_data_width : port_b_data_width;
parameter address_width      = (mode_is_rom_or_sp | primary_port_is_b) ? port_a_address_width : port_b_address_width;
parameter address_unit_width = (mode_is_rom_or_sp | primary_port_is_a) ? port_a_address_width : port_b_address_width;
parameter wired_mode         = ((port_a_address_width == 1) && (port_a_address_width == port_b_address_width)
                                                            && (port_a_data_width != port_b_data_width));

parameter num_rows = 1 << address_unit_width;
parameter num_cols = (mode_is_rom_or_sp) ? 1 : ( wired_mode ? 2 :
                      ( (primary_port_is_a) ?
                      1 << (port_b_address_width - port_a_address_width) :
                      1 << (port_a_address_width - port_b_address_width) ) ) ;

parameter mask_width_prime = (primary_port_is_a) ?
                              port_a_byte_enable_mask_width : port_b_byte_enable_mask_width;
parameter mask_width_sec   = (primary_port_is_a) ?
                              port_b_byte_enable_mask_width : port_a_byte_enable_mask_width;

parameter byte_size_a = port_a_data_width/port_a_byte_enable_mask_width;
parameter byte_size_b = port_b_data_width/port_b_byte_enable_mask_width;

// Hardware write modes
parameter dual_clock = (mode_is_dp || mode_is_bdp) &&
                        (port_b_address_clock == "clock1");

parameter hw_write_mode_a = (dual_clock || mixed_port_rdw_is_dont_care) ? "FW" : "DW";
parameter hw_write_mode_b = (dual_clock || mixed_port_rdw_is_dont_care) ? "FW" : "DW";

parameter delay_write_pulse_a = (mode_is_dp && mixed_port_rdw_is_dont_care) ? 1'b0 : ((hw_write_mode_a != "FW") ? 1'b1 : 1'b0);
parameter delay_write_pulse_b = (hw_write_mode_b != "FW") ? 1'b1 : 1'b0;

// LOCAL_PARAMETERS_END

// -------- PORT DECLARATIONS ---------
input portawe;
input portare;
input [port_a_data_width - 1:0] portadatain;
input [port_a_address_width - 1:0] portaaddr;
input [port_a_byte_enable_mask_width - 1:0] portabyteenamasks;

input portbwe, portbre;
input [port_b_data_width - 1:0] portbdatain;
input [port_b_address_width - 1:0] portbaddr;
input [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks;

input clr0,clr1;
input clk0,clk1;
input ena0,ena1;
input ena2,ena3;
input nerror;

input devclrn,devpor;
input portaaddrstall;
input portbaddrstall;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout;
output [width_eccstatus - 1:0] eccstatus;

tri0 portawe_int;
assign portawe_int = portawe;
tri1 portare_int;
assign portare_int = portare;
tri0 [port_a_data_width - 1:0] portadatain_int;
assign portadatain_int = portadatain;
tri0 [port_a_address_width - 1:0] portaaddr_int;
assign portaaddr_int = portaaddr;
tri1 [port_a_byte_enable_mask_width - 1:0] portabyteenamasks_int;
assign portabyteenamasks_int = portabyteenamasks;

tri0 portbwe_int;
assign portbwe_int = portbwe;
tri1 portbre_int;
assign portbre_int = portbre;
tri0 [port_b_data_width - 1:0] portbdatain_int;
assign portbdatain_int = portbdatain;
tri0 [port_b_address_width - 1:0] portbaddr_int;
assign portbaddr_int = portbaddr;
tri1 [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks_int;
assign portbbyteenamasks_int = portbbyteenamasks;

tri0 clr0_int,clr1_int;
assign clr0_int = clr0;
assign clr1_int = clr1;
tri0 clk0_int,clk1_int;
assign clk0_int = clk0;
assign clk1_int = clk1;
tri1 ena0_int,ena1_int;
assign ena0_int = ena0;
assign ena1_int = ena1;
tri1 ena2_int,ena3_int;
assign ena2_int = ena2;
assign ena3_int = ena3;
tri1 nerror_int;
assign nerror_int = nerror;

tri0 portaaddrstall_int;
assign portaaddrstall_int = portaaddrstall;
tri0 portbaddrstall_int;
assign portbaddrstall_int = portbaddrstall;
tri1 devclrn;
tri1 devpor;


// -------- INTERNAL signals ---------
// BIST infrastructure
wire [port_a_byte_enable_mask_width - 1:0] port_a_bist_data;
wire [port_b_byte_enable_mask_width - 1:0] port_b_bist_data;
wire [port_a_byte_enable_mask_width - 1:0] byte_enable_a;
wire [port_b_byte_enable_mask_width - 1:0] byte_enable_b;
reg [port_a_data_width - 1:0] dataout_a_in_reg;
reg [port_b_data_width - 1:0] dataout_b_in_reg;
// clock / clock enable
wire clk_a_in,clk_a_byteena,clk_a_out,clk_a_out_secmux,clkena_a_out,clkena_latch_a;
wire clk_a_rena, clk_a_wena;
wire clk_a_core;
wire clk_b_in,clk_b_byteena,clk_b_out,clk_b_out_secmux,clkena_b_out,clkena_latch_b;
wire clk_b_rena, clk_b_wena;
wire clk_b_core;

wire write_cycle_a,write_cycle_b;

// asynch clear
wire datain_a_clr,dataout_a_clr,datain_b_clr,dataout_b_clr;
wire dataout_a_clr_reg, dataout_b_clr_reg;

wire addr_a_clr,addr_b_clr;
wire byteena_a_clr,byteena_b_clr;
wire we_a_clr, we_b_clr;

wire addr_a_clr_in,addr_b_clr_in;

reg  mem_invalidate;
wire [`PRIME:`SEC] clear_asserted_during_write;
reg  clear_asserted_during_write_a,clear_asserted_during_write_b;

// port A registers
wire we_a_reg;
wire re_a_reg;
wire [port_a_address_width - 1:0] addr_a_reg;
wire [port_a_data_width - 1:0] datain_a_reg, dataout_a_reg;
reg  [port_a_data_width - 1:0] dataout_a;
wire [port_a_byte_enable_mask_width - 1:0] byteena_a_reg;

// port B registers
wire we_b_reg, re_b_reg;
wire [port_b_address_width - 1:0] addr_b_reg;
wire [port_b_data_width - 1:0] datain_b_reg, dataout_b_reg, dataout_b_signal, ecc_pipeline_b_reg;
reg  [port_b_data_width - 1:0] dataout_b;
wire [port_b_byte_enable_mask_width - 1:0] byteena_b_reg;

// placeholders for read/written data
reg  [data_width - 1:0] read_data_latch;
reg  [data_width - 1:0] mem_data;
reg  [data_width - 1:0] old_mem_data;

reg  [data_unit_width - 1:0] read_unit_data_latch;
reg  [data_width - 1:0]      mem_unit_data;

// pulses for A/B ports
wire write_pulse_a,write_pulse_b;
wire read_pulse_a,read_pulse_b;
wire read_pulse_a_feedthru,read_pulse_b_feedthru;

wire [address_unit_width - 1:0] addr_prime_reg; // registered address
wire [address_width - 1:0]      addr_sec_reg;

wire [data_width - 1:0]       datain_prime_reg; // registered data
wire [data_unit_width - 1:0]  datain_sec_reg;


// pulses for primary/secondary ports
wire write_pulse_prime,write_pulse_sec;
wire read_pulse_prime,read_pulse_sec;
wire read_pulse_prime_feedthru,read_pulse_sec_feedthru;

reg read_pulse_prime_last_value, read_pulse_sec_last_value;

reg  [`PRIME:`SEC] dual_write;  // simultaneous write to same location

// (row,column) coordinates
reg  [address_unit_width - 1:0] row_sec;
reg  [address_width + data_unit_width - address_unit_width - 1:0] col_sec;

// memory core
reg  [data_width - 1:0] mem [num_rows - 1:0];

// byte enable
wire [data_width - 1:0]      mask_vector_prime, mask_vector_prime_int;
wire [data_unit_width - 1:0] mask_vector_sec,   mask_vector_sec_int;

reg  [data_unit_width - 1:0] mask_vector_common_int;

reg  [port_a_data_width - 1:0] mask_vector_a, mask_vector_a_int;
reg  [port_b_data_width - 1:0] mask_vector_b, mask_vector_b_int;

// memory initialization
integer i,j,k,l;
integer addr_range_init;
reg [data_width - 1:0] init_mem_word;
reg [(port_a_last_address - port_a_first_address + 1)*port_a_data_width - 1:0] mem_init;

// port active for read/write
wire  active_a_in, active_b_in;
wire active_a_core,active_a_core_in,active_b_core,active_b_core_in;
wire  active_write_a,active_write_b,active_write_clear_a,active_write_clear_b;

initial
begin
    // powerup output latches to 0
    dataout_a = 'b0;
    if (mode_is_dp || mode_is_bdp) 
        dataout_b = 'b0;
    if (power_up_uninitialized == "false")
        for (i = 0; i < num_rows; i = i + 1) 
            mem[i] = 'b0;
    if ((init_file_layout == "port_a") || (init_file_layout == "port_b"))
    begin
        mem_init = { strtobits(mem_init9), strtobits(mem_init8), 
	             strtobits(mem_init7), strtobits(mem_init6),
	             strtobits(mem_init5), strtobits(mem_init4),
	             strtobits(mem_init3), strtobits(mem_init2),
	             strtobits(mem_init1), strtobits(mem_init0)
        };
        addr_range_init  = (primary_port_is_a) ?
                        port_a_last_address - port_a_first_address + 1 :
                        port_b_last_address - port_b_first_address + 1 ;
        for (j = 0; j < addr_range_init; j = j + 1)
        begin
            for (k = 0; k < data_width; k = k + 1)
                init_mem_word[k] = mem_init[j*data_width + k];
            mem[j] = init_mem_word;
        end
    end
    dual_write = 'b0;
end

assign port_a_bist_data = (bist_ena == "true") ? portabyteenamasks_int : 'b0 ;
assign port_b_bist_data = (bist_ena == "true") ? portbbyteenamasks_int : 'b0 ;
assign byte_enable_a = (bist_ena == "true") ? 'b1 : byteena_a_reg ;
assign byte_enable_b = (bist_ena == "true") ? 'b1 : byteena_b_reg ;

assign clk_a_in      = clk0_int;
assign clk_a_wena = (port_a_write_enable_clock == "none") ? 1'b0 : clk0_int;
assign clk_a_rena = (port_a_read_enable_clock  == "none") ? 1'b0 : clk0_int;
// The byte enable registers are not preset to '1'.
assign clk_a_byteena = clk0_int;
assign clk_a_out_secmux = (port_a_data_out_clock == "none")    ? 1'b0 : (
                       (port_a_data_out_clock == "clock0")  ? clk0_int : clk1_int);
assign clk_a_out = clk_a_out_secmux & nerror_int;

assign clk_b_in      = (port_b_address_clock == "clock0") ? clk0_int : clk1_int;
// The byte enable registers are not preset to '1'.
assign clk_b_byteena = (port_b_data_in_clock == "clock0") ? clk0_int : clk1_int;
assign clk_b_wena = (port_b_write_enable_clock == "none")   ? 1'b0 : (
                    (port_b_write_enable_clock == "clock0") ? clk0_int : clk1_int);
assign clk_b_rena = (port_b_read_enable_clock  == "none")   ? 1'b0 : (
                    (port_b_read_enable_clock  == "clock0") ? clk0_int : clk1_int);

assign clk_b_out_secmux = (port_b_data_out_clock == "none")      ? 1'b0 : (
                       (port_b_data_out_clock == "clock0")    ? clk0_int : clk1_int);
assign clk_b_out = clk_b_out_secmux & nerror_int;

assign addr_a_clr_in = (port_a_address_clear == "none")   ? 1'b0 : clr0_int;
assign addr_b_clr_in = (port_b_address_clear == "none")   ? 1'b0 : (
                       (port_b_address_clear == "clear0") ? clr0_int : clr1_int);

assign dataout_a_clr    = (port_a_data_out_clear == "none")   ? 1'b0 : (
                           (port_a_data_out_clear == "clear0") ? clr0_int : clr1_int);

assign dataout_b_clr    = (port_b_data_out_clear == "none")   ? 1'b0 : (
                           (port_b_data_out_clear == "clear0") ? clr0_int : clr1_int);

assign active_a_in = (clk0_input_clock_enable == "none") ? 1'b1 : (
                     (clk0_input_clock_enable == "ena0") ? ena0_int : ena2_int
                     );

assign active_a_core_in = (clk0_core_clock_enable == "none") ? 1'b1 : (
                          (clk0_core_clock_enable == "ena0") ? ena0_int : ena2_int
                          );

assign active_b_in = (port_b_address_clock == "clock0")  ? (
                           (clk0_input_clock_enable == "none") ? 1'b1 : ((clk0_input_clock_enable == "ena0") ? ena0_int : ena2_int)
                     ) : (
                           (clk1_input_clock_enable == "none") ? 1'b1 : ((clk1_input_clock_enable == "ena1") ? ena1_int : ena3_int)
                     );

assign active_b_core_in = (port_b_address_clock == "clock0")  ?  (
                              (clk0_core_clock_enable == "none") ? 1'b1 : ((clk0_core_clock_enable == "ena0") ? ena0_int : ena2_int)
                              ) : (
                                  (clk1_core_clock_enable == "none") ? 1'b1 : ((clk1_core_clock_enable == "ena1") ? ena1_int : ena3_int)
                              );


assign active_write_a = (byte_enable_a !== 'b0);


assign active_write_b = (byte_enable_b !== 'b0);

// Store core clock enable value for delayed write
// port A core active
common_28nm_ram_register active_core_port_a (
       .d(active_a_core_in),
       .clk(clk_a_in),
       .aclr(1'b0),
       .devclrn(1'b1),
       .devpor(1'b1),
       .stall(1'b0),
       .ena(1'b1),
       .q(active_a_core),.aclrout()
);
defparam active_core_port_a.width = 1;

// port B core active
common_28nm_ram_register active_core_port_b (
       .d(active_b_core_in),
       .clk(clk_b_in),
       .aclr(1'b0),
       .devclrn(1'b1),
       .devpor(1'b1),
       .stall(1'b0),
       .ena(1'b1),
       .q(active_b_core),.aclrout()
);
defparam active_core_port_b.width = 1;


// ------- A input registers -------
// write enable
common_28nm_ram_register we_a_register (
        .d(mode_is_rom ? 1'b0 : portawe_int),
        .clk(clk_a_wena),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(active_a_core_in),
        .q(we_a_reg),
        .aclrout(we_a_clr)
        );
defparam we_a_register.width = 1;

// read enable
common_28nm_ram_register re_a_register (
        .d(portare_int),
        .clk(clk_a_rena),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(active_a_core_in),
        .q(re_a_reg),
        .aclrout()
        );

// address
common_28nm_ram_register addr_a_register (
        .d(portaaddr_int),
        .clk(clk_a_in),
        .aclr(addr_a_clr_in),
        .devclrn(devclrn),
	.devpor(devpor),
        .stall(portaaddrstall_int),
        .ena(active_a_in),
        .q(addr_a_reg),
        .aclrout(addr_a_clr)
        );
defparam addr_a_register.width = port_a_address_width;

// data
common_28nm_ram_register datain_a_register (
        .d(portadatain_int),
        .clk(clk_a_in),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(active_a_in),
        .q(datain_a_reg),
        .aclrout(datain_a_clr)
        );
defparam datain_a_register.width = port_a_data_width;

// byte enable
common_28nm_ram_register byteena_a_register (
        .d(portabyteenamasks_int),
        .clk(clk_a_byteena),
        .aclr(1'b0),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_a_in),
        .q(byteena_a_reg),
        .aclrout(byteena_a_clr)
        );
defparam byteena_a_register.width = port_a_byte_enable_mask_width;

// ------- B input registers -------

// write enable

common_28nm_ram_register we_b_register (
        .d(portbwe_int),
        .clk(clk_b_wena),
        .aclr(1'b0),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
         .ena(active_b_core_in),
        .q(we_b_reg),
        .aclrout(we_b_clr)
        );
defparam we_b_register.width = 1;
defparam we_b_register.preset = 1'b0;

// read enable

common_28nm_ram_register re_b_register (
        .d(portbre_int),
        .clk(clk_b_rena),
        .aclr(1'b0),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
         .ena(active_b_core_in),
        .q(re_b_reg),
        .aclrout()
        );
defparam re_b_register.width = 1;
defparam re_b_register.preset = 1'b0;



// address
common_28nm_ram_register addr_b_register (
        .d(portbaddr_int),
        .clk(clk_b_in),
        .aclr(addr_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(portbaddrstall_int),
        .ena(active_b_in),
        .q(addr_b_reg),
        .aclrout(addr_b_clr)
        );
defparam addr_b_register.width = port_b_address_width;

// data
common_28nm_ram_register datain_b_register (
        .d(portbdatain_int),
        .clk(clk_b_in),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(active_b_in),
        .q(datain_b_reg),
        .aclrout(datain_b_clr)
        );
defparam datain_b_register.width = port_b_data_width;

// byte enable
common_28nm_ram_register byteena_b_register (
        .d(portbbyteenamasks_int),
        .clk(clk_b_byteena),
        .aclr(1'b0),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_b_in),
        .q(byteena_b_reg),
        .aclrout(byteena_b_clr)
        );
defparam byteena_b_register.width  = port_b_byte_enable_mask_width;

assign datain_prime_reg = (primary_port_is_a) ? datain_a_reg : datain_b_reg;
assign addr_prime_reg   = (primary_port_is_a) ? addr_a_reg   : addr_b_reg;

assign datain_sec_reg   = (primary_port_is_a) ? datain_b_reg : datain_a_reg;
assign addr_sec_reg     = (primary_port_is_a) ? addr_b_reg   : addr_a_reg;

assign mask_vector_prime     = (primary_port_is_a) ? mask_vector_a     : mask_vector_b;
assign mask_vector_prime_int = (primary_port_is_a) ? mask_vector_a_int :  mask_vector_b_int;

assign mask_vector_sec       = (primary_port_is_a) ? mask_vector_b     : mask_vector_a;
assign mask_vector_sec_int   = (primary_port_is_a) ? mask_vector_b_int : mask_vector_a_int;

// Hardware Write Modes
// Write pulse generation
common_28nm_ram_pulse_generator wpgen_a (
       .clk(clk_a_in),
       .ena(active_a_core & active_write_a & we_a_reg),
        .pulse(write_pulse_a),
        .cycle(write_cycle_a)
        );
defparam wpgen_a.delay_pulse = delay_write_pulse_a;

common_28nm_ram_pulse_generator wpgen_b (
       .clk(clk_b_in),
       .ena(active_b_core & active_write_b & mode_is_bdp & we_b_reg),
        .pulse(write_pulse_b),
        .cycle(write_cycle_b)
        );
defparam wpgen_b.delay_pulse = delay_write_pulse_b;

// Read pulse generation
common_28nm_ram_pulse_generator rpgen_a (
        .clk(clk_a_in),
        .ena(active_a_core & re_a_reg & ~we_a_reg & (~dataout_a_clr || out_a_is_reg)),
        .pulse(read_pulse_a),
       .cycle(clk_a_core)
        );

common_28nm_ram_pulse_generator rpgen_b (
        .clk(clk_b_in),
        .ena((mode_is_dp | mode_is_bdp) & active_b_core & re_b_reg & ~we_b_reg & (~dataout_b_clr || out_b_is_reg)),
        .pulse(read_pulse_b),
       .cycle(clk_b_core)
        );

assign write_pulse_prime = (primary_port_is_a) ? write_pulse_a : write_pulse_b;
assign read_pulse_prime  = (primary_port_is_a) ? read_pulse_a : read_pulse_b;
assign read_pulse_prime_feedthru = (primary_port_is_a) ? read_pulse_a_feedthru : read_pulse_b_feedthru;

assign write_pulse_sec = (primary_port_is_a) ? write_pulse_b : write_pulse_a;
assign read_pulse_sec  = (primary_port_is_a) ? read_pulse_b : read_pulse_a;
assign read_pulse_sec_feedthru = (primary_port_is_a) ? read_pulse_b_feedthru : read_pulse_a_feedthru;

// Create internal masks for byte enable processing
always @(byte_enable_a)
begin
    for (i = 0; i < port_a_data_width; i = i + 1)
    begin
        mask_vector_a[i]     = (byte_enable_a[i/byte_size_a] === 1'b1) ? 1'b0 : 1'bx;
        mask_vector_a_int[i] = (byte_enable_a[i/byte_size_a] === 1'b0) ? 1'b0 : 1'bx;
    end
end

always @(byte_enable_b)
begin
    for (l = 0; l < port_b_data_width; l = l + 1)
    begin
        mask_vector_b[l]     = (byte_enable_b[l/byte_size_b] === 1'b1) ? 1'b0 : 1'bx;
        mask_vector_b_int[l] = (byte_enable_b[l/byte_size_b] === 1'b0) ? 1'b0 : 1'bx;
    end
end

// BIST output handling
always @(dataout_a or port_a_bist_data)
begin
    if (bist_ena == "true")
    begin
        for (i = 0; i < port_a_data_width; i = i + 1)
        begin
            dataout_a_in_reg[i] = port_a_bist_data[i/byte_size_a] ^ dataout_a[i];
        end
    end
    else
    begin
    	dataout_a_in_reg = dataout_a;
    end
end

always @(dataout_b_signal or port_b_bist_data)
begin
    if (bist_ena == "true")
    begin
        for (i = 0; i < port_b_data_width; i = i + 1)
        begin
            dataout_b_in_reg[i] = port_b_bist_data[i/byte_size_b] ^ dataout_b_signal[i];
        end
    end
    else
    begin
    	dataout_b_in_reg = dataout_b_signal;
    end
end

// Latch Clear port A - only if the output is unregistered
always @(posedge dataout_a_clr)
begin
    if (primary_port_is_a) 
    begin 
    	if (port_a_data_out_clock == "none") 
	begin 
		read_data_latch <= 'b0;
		dataout_a <= 'b0; 
	end
    end
    else                   
    begin 
    	if (port_a_data_out_clock == "none") 
	begin 
		read_unit_data_latch <= 'b0;
		dataout_a <= 'b0; 
	end
    end
end


// Latch Clear port B - only if the output is unregistered
always @(posedge dataout_b_clr)
begin
    if (primary_port_is_b) 
    begin 
    	if (port_b_data_out_clock == "none") 
	begin 
		read_data_latch <= 'b0; 
		dataout_b <= 'b0; 
	end
    end
    else                   
    begin 
    	if (port_b_data_out_clock == "none") 
	begin 
		read_unit_data_latch <= 'b0;
		dataout_b <= 'b0; 
	end
    end
end

always @(posedge write_pulse_prime or posedge write_pulse_sec or
         posedge read_pulse_prime or posedge read_pulse_sec
        )
begin

    // Write stage 1 : write X to memory
    if (write_pulse_prime)
    begin
        old_mem_data = mem[addr_prime_reg];
        mem_data = mem[addr_prime_reg] ^ mask_vector_prime_int;
        mem[addr_prime_reg] = mem_data;
	if ((row_sec == addr_prime_reg) && (read_pulse_sec))
	begin
	    mem_unit_data = (mixed_port_rdw_is_dont_care) ? {data_width{1'bx}} : old_mem_data;
	    for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
                read_unit_data_latch[j - col_sec] = mem_unit_data[j];
	end
    end
    if (write_pulse_sec)
    begin
        row_sec = addr_sec_reg / num_cols; col_sec = (addr_sec_reg % num_cols) * data_unit_width;
        mem_unit_data = mem[row_sec];
        for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
            mem_unit_data[j] = mem_unit_data[j] ^ mask_vector_sec_int[j - col_sec];
        mem[row_sec] = mem_unit_data;
    end

    if ((addr_prime_reg == row_sec) && write_pulse_prime && write_pulse_sec) dual_write = 2'b11;

    // Read stage 1 : read data from memory

    if (read_pulse_prime && read_pulse_prime !== read_pulse_prime_last_value)
    begin
       read_data_latch = mem[addr_prime_reg];
       read_pulse_prime_last_value = read_pulse_prime;
    end

    if (read_pulse_sec && read_pulse_sec !== read_pulse_sec_last_value)
    begin
        row_sec = addr_sec_reg / num_cols; col_sec = (addr_sec_reg % num_cols) * data_unit_width;
        if ((row_sec == addr_prime_reg) && (write_pulse_prime))
	    mem_unit_data = (mixed_port_rdw_is_dont_care) ? {data_width{1'bx}} : old_mem_data;
        else
            mem_unit_data = mem[row_sec];
        for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
            read_unit_data_latch[j - col_sec] = mem_unit_data[j];
        read_pulse_sec_last_value = read_pulse_sec;
    end
end

// Simultaneous write to same/overlapping location by both ports
always @(dual_write)
begin
    if (dual_write == 2'b11)
    begin
           for (i = 0; i < data_unit_width; i = i + 1)
               mask_vector_common_int[i] = mask_vector_prime_int[col_sec + i] &
                                           mask_vector_sec_int[i];
    end
    else if (dual_write == 2'b01) mem_unit_data = mem[row_sec];
    else if (dual_write == 'b0)
    begin
       mem_data = mem[addr_prime_reg];
       for (i = 0; i < data_unit_width; i = i + 1)
               mem_data[col_sec + i] = mem_data[col_sec + i] ^ mask_vector_common_int[i];
       mem[addr_prime_reg] = mem_data;
    end
end

// Write stage 2 : Write actual data to memory
always @(negedge write_pulse_prime)
begin
    if (clear_asserted_during_write[`PRIME] !== 1'b1)
    begin
        for (i = 0; i < data_width; i = i + 1)
            if (mask_vector_prime[i] == 1'b0)
                mem_data[i] = datain_prime_reg[i];
        mem[addr_prime_reg] = mem_data;
    end
    dual_write[`PRIME] = 1'b0;
end

always @(negedge write_pulse_sec)
begin
    if (clear_asserted_during_write[`SEC] !== 1'b1)
    begin
        for (i = 0; i < data_unit_width; i = i + 1)
            if (mask_vector_sec[i] == 1'b0)
                mem_unit_data[col_sec + i] = datain_sec_reg[i];
        mem[row_sec] = mem_unit_data;
    end
    dual_write[`SEC] = 1'b0;
end

always @(negedge read_pulse_prime) read_pulse_prime_last_value = 1'b0;
always @(negedge read_pulse_sec)   read_pulse_sec_last_value = 1'b0;


// Read stage 2 : Send data to output
always @(negedge read_pulse_prime)
begin
    if (primary_port_is_a)
	begin
		if(~dataout_a_clr_reg || out_a_is_reg)
        dataout_a = read_data_latch;
	end
    else
	begin
		if(~dataout_b_clr_reg || out_b_is_reg)
        dataout_b = read_data_latch;
	end
end

always @(negedge read_pulse_sec)
begin
    if (primary_port_is_b)
	begin
		if(~dataout_a_clr_reg || out_a_is_reg)
        dataout_a = read_unit_data_latch;
	end
    else
	begin
		if(~dataout_b_clr_reg || out_b_is_reg)
        dataout_b = read_unit_data_latch;
	end
end

// Same port feed through
common_28nm_ram_pulse_generator ftpgen_a (
        .clk(clk_a_in),
           .ena(active_a_core & ~mode_is_dp & we_a_reg & re_a_reg & (~dataout_a_clr || out_a_is_reg)),
        .pulse(read_pulse_a_feedthru),.cycle()
        );

common_28nm_ram_pulse_generator ftpgen_b (
        .clk(clk_b_in),
           .ena(active_b_core & mode_is_bdp & we_b_reg & re_b_reg & (~dataout_b_clr || out_b_is_reg)),
        .pulse(read_pulse_b_feedthru),.cycle()
        );

always @(negedge read_pulse_prime_feedthru)
begin
    if (primary_port_is_a)
    begin
		if(~dataout_a_clr_reg || out_a_is_reg)
		begin
			dataout_a = datain_prime_reg ^ mask_vector_prime;
		end
    end
    else
    begin
		if(~dataout_b_clr_reg || out_b_is_reg)
		begin
			dataout_b = datain_prime_reg ^ mask_vector_prime;
		end
    end
end

always @(negedge read_pulse_sec_feedthru)
begin
    if (primary_port_is_b)
    begin
		if(~dataout_a_clr_reg || out_a_is_reg)
		begin
			dataout_a = datain_sec_reg ^ mask_vector_sec;
		end
    end
    else
    begin
		if(~dataout_b_clr_reg || out_b_is_reg)
		begin
			dataout_b = datain_sec_reg ^ mask_vector_sec;
		end
    end
end

// Input register clears

always @(posedge addr_a_clr or posedge datain_a_clr or posedge we_a_clr)
    clear_asserted_during_write_a = write_pulse_a;

assign active_write_clear_a = active_write_a & write_cycle_a;

always @(posedge addr_a_clr)
begin
    if (active_write_clear_a & we_a_reg)
        mem_invalidate = 1'b1;
 else if (active_a_core & re_a_reg)
    begin
        if (primary_port_is_a)
        begin
            read_data_latch = 'bx;
        end
        else
        begin
            read_unit_data_latch = 'bx;
        end
        dataout_a = 'bx;
    end
end

always @(posedge datain_a_clr or posedge we_a_clr)
begin
    if (active_write_clear_a & we_a_reg)
    begin
        if (primary_port_is_a)
            mem[addr_prime_reg] = 'bx;
        else
        begin
            mem_unit_data = mem[row_sec];
            for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
                mem_unit_data[j] = 1'bx;
            mem[row_sec] = mem_unit_data;
        end
        if (primary_port_is_a)
        begin
            read_data_latch = 'bx;
        end
        else
        begin
            read_unit_data_latch = 'bx;
        end
    end
end

assign active_write_clear_b = active_write_b & write_cycle_b;

always @(posedge addr_b_clr or posedge datain_b_clr or
        posedge we_b_clr)
    clear_asserted_during_write_b = write_pulse_b;

always @(posedge addr_b_clr)
begin
   if (mode_is_bdp & active_write_clear_b & we_b_reg)
        mem_invalidate = 1'b1;
  else if ((mode_is_dp | mode_is_bdp) & active_b_core & re_b_reg)
    begin
        if (primary_port_is_b)
        begin
            read_data_latch = 'bx;
        end
        else
        begin
            read_unit_data_latch = 'bx;
        end
        dataout_b = 'bx;
    end
end

always @(posedge datain_b_clr or posedge we_b_clr)
begin
   if (mode_is_bdp & active_write_clear_b & we_b_reg)

    begin
        if (primary_port_is_b)
            mem[addr_prime_reg] = 'bx;
        else
        begin
            mem_unit_data = mem[row_sec];
            for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
                 mem_unit_data[j] = 'bx;
            mem[row_sec] = mem_unit_data;
        end
        if (primary_port_is_b)
        begin
            read_data_latch = 'bx;
        end
        else
        begin
            read_unit_data_latch = 'bx;
        end
    end
end

assign clear_asserted_during_write[primary_port_is_a] = clear_asserted_during_write_a;
assign clear_asserted_during_write[primary_port_is_b] = clear_asserted_during_write_b;

always @(posedge mem_invalidate)
begin
    for (i = 0; i < num_rows; i = i + 1) mem[i] = 'bx;
    mem_invalidate = 1'b0;
end

 // ------- Aclr mux registers (Latch Clear) --------
 
 //case:32394 - clear deassertion on output latch dependent on outclk, future support
 assign clkena_latch_a = (clk0_output_clock_enable == "ena0" ) ? (ena0_int | dataout_a_clr) : 1'b1;
 assign clkena_latch_b = (clk0_output_clock_enable == "ena0" && port_b_address_clock == "clock0") ? (ena0_int | dataout_b_clr ): 
					((clk1_output_clock_enable == "ena1" && port_b_address_clock == "clock1") ? (ena1_int | dataout_b_clr ) : 1'b1);

 
 // port A
 common_28nm_ram_register aclr__a__mux_register (
        .d(dataout_a_clr),
        .clk(clk_a_core),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(clkena_latch_a),
        .q(dataout_a_clr_reg),.aclrout()
        );
 // port B
 common_28nm_ram_register aclr__b__mux_register (
        .d(dataout_b_clr),
        .clk(clk_b_core),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(clkena_latch_b),
        .q(dataout_b_clr_reg),.aclrout()
        );


// ------- ECC Pipeline registers --------

common_28nm_ram_register ecc_pipeline_b_register (
        .d( dataout_b ),
        .clk(clk_b_out),
 	.aclr(dataout_b_clr),
        .devclrn(devclrn),.devpor(devpor),
        .stall(1'b0),
        .ena(clkena_b_out),
        .q(ecc_pipeline_b_reg),.aclrout()
        );
defparam ecc_pipeline_b_register.width = port_b_data_width;

assign dataout_b_signal = (enable_ecc == "true" && ecc_pipeline_stage_enabled == "true") ? ecc_pipeline_b_reg : dataout_b ;

// ------- Output registers --------

assign clkena_a_out = (port_a_data_out_clock == "clock0") ?
                       ((clk0_output_clock_enable == "none") ? 1'b1 : ena0_int) :
                       ((clk1_output_clock_enable == "none") ? 1'b1 : ena1_int) ;

common_28nm_ram_register dataout_a_register (
        .d(dataout_a_in_reg),
        .clk(clk_a_out),
 	.aclr(dataout_a_clr),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(clkena_a_out),
        .q(dataout_a_reg),.aclrout()
        );
defparam dataout_a_register.width = port_a_data_width;

 reg [port_a_data_width - 1:0] portadataout_clr;
 reg [port_b_data_width - 1:0] portbdataout_clr;
 initial
 begin
     portadataout_clr = 'b0;
     portbdataout_clr = 'b0;
 end

 assign portadataout =  (out_a_is_reg) ? dataout_a_reg : (
                            (dataout_a_clr || dataout_a_clr_reg) ? portadataout_clr : dataout_a_in_reg
                       );

assign clkena_b_out = (port_b_data_out_clock == "clock0") ?
                       ((clk0_output_clock_enable == "none") ? 1'b1 : ena0_int) :
                       ((clk1_output_clock_enable == "none") ? 1'b1 : ena1_int) ;

common_28nm_ram_register dataout_b_register (
        .d( dataout_b_in_reg ),
        .clk(clk_b_out),
 	.aclr(dataout_b_clr),
        .devclrn(devclrn),.devpor(devpor),
        .stall(1'b0),
        .ena(clkena_b_out),
        .q(dataout_b_reg),.aclrout()
        );
defparam dataout_b_register.width = port_b_data_width;

assign portbdataout = (out_b_is_reg) ? dataout_b_reg : (
                          (dataout_b_clr || dataout_b_clr_reg) ? portbdataout_clr : dataout_b_in_reg
                      );

assign eccstatus = {width_eccstatus{1'b0}};

endmodule // common_28nm_ram_block

//--------------------------------------------------------------------------
// Module Name     : generic_m20k
// Description     : Wrapper around the common 28nm RAM block
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module generic_m20k
    (
     portadatain,
     portaaddr,
     portawe,
     portare,
     portbdatain,
     portbaddr,
     portbwe,
     portbre,
     clk0, clk1,
     ena0, ena1,
     ena2, ena3,
     clr0, clr1,
     nerror,
     portabyteenamasks,
     portbbyteenamasks,
     portaaddrstall,
     portbaddrstall,
     devclrn,
     devpor,
     eccstatus,
     portadataout,
     portbdataout
      ,dftout
     );
// -------- GLOBAL PARAMETERS ---------
parameter operation_mode = "single_port";
parameter mixed_port_feed_through_mode = "dont_care";
parameter ram_block_type = "auto";
parameter logical_ram_name = "ram_name";

parameter init_file = "init_file.hex";
parameter init_file_layout = "none";

parameter ecc_pipeline_stage_enabled = "false";
parameter enable_ecc = "false";
parameter width_eccstatus = 2;
parameter data_interleave_width_in_bits = 1;
parameter data_interleave_offset_in_bits = 1;
parameter port_a_logical_ram_depth = 0;
parameter port_a_logical_ram_width = 0;
parameter port_a_first_address = 0;
parameter port_a_last_address = 0;
parameter port_a_first_bit_number = 0;

parameter port_a_data_out_clear = "none";

parameter port_a_data_out_clock = "none";

parameter port_a_data_width = 1;
parameter port_a_address_width = 1;
parameter port_a_byte_enable_mask_width = 1;

parameter port_b_logical_ram_depth = 0;
parameter port_b_logical_ram_width = 0;
parameter port_b_first_address = 0;
parameter port_b_last_address = 0;
parameter port_b_first_bit_number = 0;

parameter port_b_address_clear = "none";
parameter port_b_data_out_clear = "none";

parameter port_b_data_in_clock = "clock1";
parameter port_b_address_clock = "clock1";
parameter port_b_write_enable_clock = "clock1";
parameter port_b_read_enable_clock  = "clock1";
parameter port_b_byte_enable_clock = "clock1";
parameter port_b_data_out_clock = "none";

parameter port_b_data_width = 1;
parameter port_b_address_width = 1;
parameter port_b_byte_enable_mask_width = 1;

parameter port_a_read_during_write_mode = "new_data_no_nbe_read";
parameter port_b_read_during_write_mode = "new_data_no_nbe_read";
parameter power_up_uninitialized = "false";
parameter lpm_type = "stratixv_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

parameter mem_init0 = "";
parameter mem_init1 = "";
parameter mem_init2 = "";
parameter mem_init3 = "";
parameter mem_init4 = "";
parameter mem_init5 = "";
parameter mem_init6 = "";
parameter mem_init7 = "";
parameter mem_init8 = "";
parameter mem_init9 = "";

parameter port_a_byte_size = 0;
parameter port_b_byte_size = 0;

parameter clk0_input_clock_enable  = "none"; // ena0,ena2,none
parameter clk0_core_clock_enable   = "none"; // ena0,ena2,none
parameter clk0_output_clock_enable = "none"; // ena0,none
parameter clk1_input_clock_enable  = "none"; // ena1,ena3,none
parameter clk1_core_clock_enable   = "none"; // ena1,ena3,none
parameter clk1_output_clock_enable = "none"; // ena1,none

parameter bist_ena = "false"; //false, true 

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter port_a_address_clear = "none";

parameter port_a_data_in_clock = "clock0";
parameter port_a_address_clock = "clock0";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_byte_enable_clock = "clock0";
parameter port_a_read_enable_clock = "clock0";

// SIMULATION_ONLY_PARAMETERS_END

// -------- PORT DECLARATIONS ---------
input portawe;
input portare;
input [port_a_data_width - 1:0] portadatain;
input [port_a_address_width - 1:0] portaaddr;
input [port_a_byte_enable_mask_width - 1:0] portabyteenamasks;

input portbwe, portbre;
input [port_b_data_width - 1:0] portbdatain;
input [port_b_address_width - 1:0] portbaddr;
input [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks;

input clr0,clr1;
input clk0,clk1;
input ena0,ena1;
input ena2,ena3;
input nerror;

input devclrn,devpor;
input portaaddrstall;
input portbaddrstall;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout;
output [width_eccstatus - 1:0] eccstatus;
output [8:0] dftout;


// -------- RAM BLOCK INSTANTIATION ---
common_28nm_ram_block ram_core0
(
	.portawe(portawe),
	.portare(portare),
	.portadatain(portadatain),
	.portaaddr(portaaddr),
	.portabyteenamasks(portabyteenamasks),
	.portbwe(portbwe),
	.portbre(portbre),
	.portbdatain(portbdatain),
	.portbaddr(portbaddr),
	.portbbyteenamasks(portbbyteenamasks),
	.clr0(clr0),
	.clr1(clr1),
	.clk0(clk0),
	.clk1(clk1),
	.ena0(ena0),
	.ena1(ena1),
	.ena2(ena2),
	.ena3(ena3),
	.nerror(nerror),
	.devclrn(devclrn),
	.devpor(devpor),
	.portaaddrstall(portaaddrstall),
	.portbaddrstall(portbaddrstall),
	.portadataout(portadataout),
	.portbdataout(portbdataout),
	.eccstatus(eccstatus)
);
defparam ram_core0.operation_mode = operation_mode;
defparam ram_core0.mixed_port_feed_through_mode = mixed_port_feed_through_mode;
defparam ram_core0.init_file_layout = init_file_layout;
defparam ram_core0.ecc_pipeline_stage_enabled = ecc_pipeline_stage_enabled;
defparam ram_core0.enable_ecc = enable_ecc;
defparam ram_core0.width_eccstatus = width_eccstatus;
defparam ram_core0.port_a_first_address = port_a_first_address;
defparam ram_core0.port_a_last_address = port_a_last_address;
defparam ram_core0.port_a_data_out_clear = port_a_data_out_clear;
defparam ram_core0.port_a_data_out_clock = port_a_data_out_clock;
defparam ram_core0.port_a_data_width = port_a_data_width;
defparam ram_core0.port_a_address_width = port_a_address_width;
defparam ram_core0.port_a_byte_enable_mask_width = port_a_byte_enable_mask_width;
defparam ram_core0.port_b_first_address = port_b_first_address;
defparam ram_core0.port_b_last_address = port_b_last_address;
defparam ram_core0.port_b_address_clear = port_b_address_clear;
defparam ram_core0.port_b_data_out_clear = port_b_data_out_clear;
defparam ram_core0.port_b_data_in_clock = port_b_data_in_clock;
defparam ram_core0.port_b_address_clock = port_b_address_clock;
defparam ram_core0.port_b_write_enable_clock = port_b_write_enable_clock;
defparam ram_core0.port_b_read_enable_clock = port_b_read_enable_clock;
defparam ram_core0.port_b_byte_enable_clock = port_b_byte_enable_clock;
defparam ram_core0.port_b_data_out_clock = port_b_data_out_clock;
defparam ram_core0.port_b_data_width = port_b_data_width;
defparam ram_core0.port_b_address_width = port_b_address_width;
defparam ram_core0.port_b_byte_enable_mask_width = port_b_byte_enable_mask_width;
defparam ram_core0.power_up_uninitialized = power_up_uninitialized;
defparam ram_core0.mem_init0 = mem_init0;
defparam ram_core0.mem_init1 = mem_init1;
defparam ram_core0.mem_init2 = mem_init2;
defparam ram_core0.mem_init3 = mem_init3;
defparam ram_core0.mem_init4 = mem_init4;
defparam ram_core0.mem_init5 = mem_init5;
defparam ram_core0.mem_init6 = mem_init6;
defparam ram_core0.mem_init7 = mem_init7;
defparam ram_core0.mem_init8 = mem_init8;
defparam ram_core0.mem_init9 = mem_init9;
defparam ram_core0.clk0_input_clock_enable = clk0_input_clock_enable;
defparam ram_core0.clk0_core_clock_enable = clk0_core_clock_enable ;
defparam ram_core0.clk0_output_clock_enable = clk0_output_clock_enable;
defparam ram_core0.clk1_input_clock_enable = clk1_input_clock_enable;
defparam ram_core0.clk1_core_clock_enable = clk1_core_clock_enable;
defparam ram_core0.clk1_output_clock_enable = clk1_output_clock_enable;
defparam ram_core0.bist_ena = bist_ena;
defparam ram_core0.port_a_address_clear = port_a_address_clear;
defparam ram_core0.port_a_write_enable_clock = port_a_write_enable_clock;
defparam ram_core0.port_a_read_enable_clock = port_a_read_enable_clock;

endmodule // m20k_ram_block


//--------------------------------------------------------------------------
// Module Name     : generic_m10k
// Description     : Wrapper around the common 28nm RAM block
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module generic_m10k
    (
     portadatain,
     portaaddr,
     portawe,
     portare,
     portbdatain,
     portbaddr,
     portbwe,
     portbre,
     clk0, clk1,
     ena0, ena1,
     ena2, ena3,
     clr0, clr1,
     nerror,
     portabyteenamasks,
     portbbyteenamasks,
     portaaddrstall,
     portbaddrstall,
     devclrn,
     devpor,
     eccstatus,
     portadataout,
     portbdataout
      ,dftout
     );
// -------- GLOBAL PARAMETERS ---------
parameter operation_mode = "single_port";
parameter mixed_port_feed_through_mode = "dont_care";
parameter ram_block_type = "auto";
parameter logical_ram_name = "ram_name";

parameter init_file = "init_file.hex";
parameter init_file_layout = "none";

parameter ecc_pipeline_stage_enabled = "false";
parameter enable_ecc = "false";
parameter width_eccstatus = 2;
parameter data_interleave_width_in_bits = 1;
parameter data_interleave_offset_in_bits = 1;
parameter port_a_logical_ram_depth = 0;
parameter port_a_logical_ram_width = 0;
parameter port_a_first_address = 0;
parameter port_a_last_address = 0;
parameter port_a_first_bit_number = 0;

parameter port_a_data_out_clear = "none";

parameter port_a_data_out_clock = "none";

parameter port_a_data_width = 1;
parameter port_a_address_width = 1;
parameter port_a_byte_enable_mask_width = 1;

parameter port_b_logical_ram_depth = 0;
parameter port_b_logical_ram_width = 0;
parameter port_b_first_address = 0;
parameter port_b_last_address = 0;
parameter port_b_first_bit_number = 0;

parameter port_b_address_clear = "none";
parameter port_b_data_out_clear = "none";

parameter port_b_data_in_clock = "clock1";
parameter port_b_address_clock = "clock1";
parameter port_b_write_enable_clock = "clock1";
parameter port_b_read_enable_clock  = "clock1";
parameter port_b_byte_enable_clock = "clock1";
parameter port_b_data_out_clock = "none";

parameter port_b_data_width = 1;
parameter port_b_address_width = 1;
parameter port_b_byte_enable_mask_width = 1;

parameter port_a_read_during_write_mode = "new_data_no_nbe_read";
parameter port_b_read_during_write_mode = "new_data_no_nbe_read";
parameter power_up_uninitialized = "false";
parameter lpm_type = "arriav_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

parameter mem_init0 = "";
parameter mem_init1 = "";
parameter mem_init2 = "";
parameter mem_init3 = "";
parameter mem_init4 = "";

parameter port_a_byte_size = 0;
parameter port_b_byte_size = 0;

parameter clk0_input_clock_enable  = "none"; // ena0,ena2,none
parameter clk0_core_clock_enable   = "none"; // ena0,ena2,none
parameter clk0_output_clock_enable = "none"; // ena0,none
parameter clk1_input_clock_enable  = "none"; // ena1,ena3,none
parameter clk1_core_clock_enable   = "none"; // ena1,ena3,none
parameter clk1_output_clock_enable = "none"; // ena1,none

parameter bist_ena = "false"; //false, true 

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter port_a_address_clear = "none";

parameter port_a_data_in_clock = "clock0";
parameter port_a_address_clock = "clock0";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_byte_enable_clock = "clock0";
parameter port_a_read_enable_clock = "clock0";

// SIMULATION_ONLY_PARAMETERS_END

// -------- PORT DECLARATIONS ---------
input portawe;
input portare;
input [port_a_data_width - 1:0] portadatain;
input [port_a_address_width - 1:0] portaaddr;
input [port_a_byte_enable_mask_width - 1:0] portabyteenamasks;

input portbwe, portbre;
input [port_b_data_width - 1:0] portbdatain;
input [port_b_address_width - 1:0] portbaddr;
input [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks;

input clr0,clr1;
input clk0,clk1;
input ena0,ena1;
input ena2,ena3;
input nerror;

input devclrn,devpor;
input portaaddrstall;
input portbaddrstall;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout;
output [width_eccstatus - 1:0] eccstatus;
output [8:0] dftout;


// -------- RAM BLOCK INSTANTIATION ---
common_28nm_ram_block ram_core0
(
	.portawe(portawe),
	.portare(portare),
	.portadatain(portadatain),
	.portaaddr(portaaddr),
	.portabyteenamasks(portabyteenamasks),
	.portbwe(portbwe),
	.portbre(portbre),
	.portbdatain(portbdatain),
	.portbaddr(portbaddr),
	.portbbyteenamasks(portbbyteenamasks),
	.clr0(clr0),
	.clr1(clr1),
	.clk0(clk0),
	.clk1(clk1),
	.ena0(ena0),
	.ena1(ena1),
	.ena2(ena2),
	.ena3(ena3),
	.nerror(nerror),
	.devclrn(devclrn),
	.devpor(devpor),
	.portaaddrstall(portaaddrstall),
	.portbaddrstall(portbaddrstall),
	.portadataout(portadataout),
	.portbdataout(portbdataout),
	.eccstatus(eccstatus)
);
defparam ram_core0.operation_mode = operation_mode;
defparam ram_core0.mixed_port_feed_through_mode = mixed_port_feed_through_mode;
defparam ram_core0.init_file_layout = init_file_layout;
defparam ram_core0.ecc_pipeline_stage_enabled = "false";
defparam ram_core0.enable_ecc = "false";
defparam ram_core0.width_eccstatus = width_eccstatus;
defparam ram_core0.port_a_first_address = port_a_first_address;
defparam ram_core0.port_a_last_address = port_a_last_address;
defparam ram_core0.port_a_data_out_clear = port_a_data_out_clear;
defparam ram_core0.port_a_data_out_clock = port_a_data_out_clock;
defparam ram_core0.port_a_data_width = port_a_data_width;
defparam ram_core0.port_a_address_width = port_a_address_width;
defparam ram_core0.port_a_byte_enable_mask_width = port_a_byte_enable_mask_width;
defparam ram_core0.port_b_first_address = port_b_first_address;
defparam ram_core0.port_b_last_address = port_b_last_address;
defparam ram_core0.port_b_address_clear = port_b_address_clear;
defparam ram_core0.port_b_data_out_clear = port_b_data_out_clear;
defparam ram_core0.port_b_data_in_clock = port_b_data_in_clock;
defparam ram_core0.port_b_address_clock = port_b_address_clock;
defparam ram_core0.port_b_write_enable_clock = port_b_write_enable_clock;
defparam ram_core0.port_b_read_enable_clock = port_b_read_enable_clock;
defparam ram_core0.port_b_byte_enable_clock = port_b_byte_enable_clock;
defparam ram_core0.port_b_data_out_clock = port_b_data_out_clock;
defparam ram_core0.port_b_data_width = port_b_data_width;
defparam ram_core0.port_b_address_width = port_b_address_width;
defparam ram_core0.port_b_byte_enable_mask_width = port_b_byte_enable_mask_width;
defparam ram_core0.power_up_uninitialized = power_up_uninitialized;
defparam ram_core0.mem_init0 = mem_init0;
defparam ram_core0.mem_init1 = mem_init1;
defparam ram_core0.mem_init2 = mem_init2;
defparam ram_core0.mem_init3 = mem_init3;
defparam ram_core0.mem_init4 = mem_init4;
defparam ram_core0.clk0_input_clock_enable = clk0_input_clock_enable;
defparam ram_core0.clk0_core_clock_enable = clk0_core_clock_enable ;
defparam ram_core0.clk0_output_clock_enable = clk0_output_clock_enable;
defparam ram_core0.clk1_input_clock_enable = clk1_input_clock_enable;
defparam ram_core0.clk1_core_clock_enable = clk1_core_clock_enable;
defparam ram_core0.clk1_output_clock_enable = clk1_output_clock_enable;
defparam ram_core0.bist_ena = bist_ena;
defparam ram_core0.port_a_address_clear = port_a_address_clear;
defparam ram_core0.port_a_write_enable_clock = port_a_write_enable_clock;
defparam ram_core0.port_a_read_enable_clock = port_a_read_enable_clock;

endmodule // m10k

// Activate again the LEDA rule that requires uppercase letters for all
// parameter names
// leda rule_G_521_3_B on





//--------------------------------------------------------------------------
// Module Name     : common_28nm_mlab_cell_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------
`timescale 1 ps/1 ps

module common_28nm_mlab_cell_pulse_generator (
                                    clk,
                                    ena,     
                                    pulse,
                                    cycle    
                                   );
input  clk;   // clock
input  ena;   // pulse enable
output pulse; // pulse
output cycle; // delayed clock

reg  state;
reg  clk_prev;
wire clk_ipd;

specify
    specparam t_decode = 0,t_access = 0;
    (posedge clk => (pulse +: state)) = (t_decode,t_access);
endspecify

buf #(1) (clk_ipd,clk);

initial clk_prev = 1'bx;

always @(clk_ipd or posedge pulse) 
begin
    if      (pulse) state <= 1'b0;
    else if (ena && clk_ipd === 1'b1 && clk_prev === 1'b0)   state <= 1'b1;
    clk_prev = clk_ipd;
end

assign cycle = clk_ipd;
assign pulse = state; 

endmodule


//--------------------------------------------------------------------------
// Module Name     : common_28nm_mlab_latch
// Description     : Latch module for write side latches (high transparent)
//--------------------------------------------------------------------------
`timescale 1 ps/1 ps

module common_28nm_mlab_latch(
                                  d,
                                  ena,
                                  q
                                  );
parameter width = 1;
parameter init_value = 0;

input [width - 1:0] d;    // data
input ena;                // enable
output [width - 1:0] q;   // register output

reg [width - 1:0] q;

initial
begin
	if(init_value == 0)
		q = '0;
	else
		q = '1;
end


always @(ena or d)
begin: latches
	if(ena)
	begin
		q = d;
	end
end

endmodule

//--------------------------------------------------------------------------
// Module Name     : common_28nm_mlab_cell_core
// Description     : Main RAM module
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module common_28nm_mlab_cell_core
    (
     datain_a_reg,
     addr_a_reg, 
     byteena_a_reg, 
     portbaddr,
     clk_a_in,
     ena0, 
     dataout_b
     );

// -------- PACKAGES ------------------

import altera_lnsim_functions::*;

// -------- GLOBAL PARAMETERS ---------

parameter first_address = 0;
parameter last_address = 0;
parameter data_width = 20;
parameter address_width = 6;
parameter byte_enable_mask_width = 1;
parameter mem_init0 = "";

// -------- PORT DECLARATIONS ---------
input [data_width - 1:0] datain_a_reg;
input [address_width - 1:0] addr_a_reg;
input [byte_enable_mask_width - 1:0] byteena_a_reg;
input [address_width - 1:0] portbaddr;

input clk_a_in;

input ena0;

output [data_width - 1:0] dataout_b;

// LOCAL_PARAMETERS_BEGIN

parameter MEM_INIT_STRING_LENGTH = 160;
parameter port_byte_size = data_width/byte_enable_mask_width;
parameter num_rows = 1 << address_width;
parameter num_cols = 1;

// LOCAL_PARAMETERS_END

reg ena0_reg;

// -------- INTERNAL signals ---------
// clock / clock enable

// placeholders for read/written data
reg  [data_width - 1:0] mem_data;

// pulses for A/B ports (no read pulse)
wire write_pulse;
wire write_cycle;

// memory core
reg  [data_width - 1:0] mem [num_rows - 1:0];

// byte enable
reg  [data_width - 1:0] mask_vector, mask_vector_int;

// memory initialization
integer i,j,k;
integer addr_range_init;
reg [data_width - 1:0] init_mem_word;
reg [(last_address - first_address + 1)*data_width - 1:0] mem_init;

// port active for read/write
wire  active_a,active_a_in;
wire  active_write_a;

initial
begin
    ena0_reg = 1'b0;

    // powerup output to 0
    for (i = 0; i < num_rows; i = i + 1) 
		mem[i] = {data_width{1'b0}};
    mem_init = strtobits(mem_init0);
    addr_range_init  = last_address - first_address + 1;
    for (j = 0; j < addr_range_init; j = j + 1)
    begin
        for (k = 0; k < data_width; k = k + 1)
            init_mem_word[k] = mem_init[j*data_width + k];
        mem[j] = init_mem_word;
    end
end

always @(posedge clk_a_in) ena0_reg <= ena0;

// Write pulse generation
common_28nm_mlab_cell_pulse_generator wpgen_a (
        .clk(clk_a_in),
        .ena(ena0_reg),
        .pulse(write_pulse),
	    .cycle(write_cycle)
        );

// Read pulse generation
// -- none --

// Create internal masks for byte enable processing
always @(byteena_a_reg)
begin
	for (i = 0; i < data_width; i = i + 1)
	begin
		if (port_byte_size == 0)
		begin
			$display("Error: Parameter data_width is smaller than parameter byte_enable_mask_width.");
			$display("Time: %0t  Instance: %m", $time);
			$finish;
		end
		if (byteena_a_reg[i/port_byte_size] === 1'b1)
			mask_vector[i] = 1'b0;
		else
			mask_vector[i] = 1'bx;

		if (byteena_a_reg[i/port_byte_size] === 1'b0)
			mask_vector_int[i] = 1'b0;
		else
			mask_vector_int[i] = 1'bx;
	end
end
                        
always @(posedge write_pulse) 
begin
    // Write stage 1 : write X to memory
    if (write_pulse)
    begin
        mem_data = mem[addr_a_reg] ^ mask_vector_int;
        mem[addr_a_reg] = mem_data;
    end
end

// Write stage 2 : Write actual data to memory
always @(negedge write_pulse)
begin
    for (i = 0; i < data_width; i = i + 1)
        if (mask_vector[i] == 1'b0)
            mem_data[i] = datain_a_reg[i];
    mem[addr_a_reg] = mem_data;
end

// Read stage : asynchronous continuous read

assign dataout_b = mem[portbaddr];

endmodule // common_28nm_mlab_cell_core

//--------------------------------------------------------------------------
// Module Name     : common_porta_latches
// Description     : Implements write side registers for Stratix V MLAB cell.
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module common_porta_latches(
        addr_d,
        datain_d,
        byteena_d,
        clk,
        ena,
        addr_q,
        datain_q,
        byteena_q
        );
parameter addr_register_width = 1;
parameter datain_register_width = 1;
parameter byteena_register_width = 1;
	
input [addr_register_width-1:0] addr_d;
input [datain_register_width-1:0] datain_d;
input [byteena_register_width-1:0] byteena_d;
input clk;
input ena;

output [addr_register_width-1:0] addr_q;
output [datain_register_width-1:0] datain_q;
output [byteena_register_width-1:0] byteena_q;

wire clk_inv;
wire latch_ena;
reg ena_buf;

// high-level transparent latches on inverted clock
assign clk_inv = ~clk;

// clock enable latch
common_28nm_mlab_latch clken_latch(
        .d(ena),
        .ena(clk),
        .q(ena_buf)
        );
defparam clken_latch.init_value = 1;

assign latch_ena = ena_buf & clk_inv;

// address latch
common_28nm_mlab_latch addr_a_latch(
        .d(addr_d),
        .ena(latch_ena),
        .q(addr_q)
        );
defparam addr_a_latch.width = addr_register_width;

// data latch
common_28nm_mlab_latch datain_a_latch(
        .d(datain_d),
        .ena(latch_ena),
        .q(datain_q)
        );
defparam datain_a_latch.width = datain_register_width;

// byte enable latch
common_28nm_mlab_latch byteena_a_latch(
        .d(byteena_d),
        .ena(latch_ena),
        .q(byteena_q)
        );
defparam byteena_a_latch.width = byteena_register_width;
defparam byteena_a_latch.init_value = 1;

endmodule

//--------------------------------------------------------------------------
// Module Name     : generic_28nm_hp_mlab_cell_impl
// Description     : Main RAM module
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module generic_28nm_hp_mlab_cell_impl
    (
     portadatain,
     portaaddr, 
     portabyteenamasks, 
     portbaddr,
     clk0, clk1,
     ena0, ena1,
     ena2,
     clr,
     devclrn,
     devpor,
     portbdataout
     );

// -------- PACKAGES ------------------

import altera_lnsim_functions::*;

// -------- GLOBAL PARAMETERS ---------

parameter logical_ram_name = "lutram";

parameter logical_ram_depth = 0;
parameter logical_ram_width = 0;
parameter first_address = 0;
parameter last_address = 0;
parameter first_bit_number = 0;

parameter mixed_port_feed_through_mode = "new";
parameter init_file = "NONE";

parameter data_width = 20;
parameter address_width = 6;
parameter byte_enable_mask_width = 1;
parameter byte_size = 1;
parameter port_b_data_out_clock = "none";
parameter port_b_data_out_clear = "none";

parameter lpm_type = "common_28nm_mlab_cell";
parameter lpm_hint = "true";

parameter mem_init0 = "";

// -------- PORT DECLARATIONS ---------
input [data_width - 1:0] portadatain;
input [address_width - 1:0] portaaddr;
input [byte_enable_mask_width - 1:0] portabyteenamasks;
input [address_width - 1:0] portbaddr;

input clk0;
input clk1;

input ena0;
input ena1;
input ena2;

input clr;

input devclrn;
input devpor;

output [data_width - 1:0] portbdataout;

tri1 devclrn;
tri1 devpor;

tri0 [data_width - 1:0] portadatain;
tri0 [address_width - 1:0] portaaddr;
tri1 [byte_enable_mask_width - 1:0] portabyteenamasks;
tri0 clr;
tri0 clk0,clk1;
tri1 ena0,ena1;
tri1 ena2;

wire clk_a_in;
wire clk_b_out;

// port A registers
wire [address_width - 1:0] addr_a_reg;
wire [data_width - 1:0] datain_a_reg;
wire [byte_enable_mask_width - 1:0] byteena_a_reg;

// port B registers
wire [data_width - 1:0] dataout_b;
wire [data_width - 1:0] dataout_b_reg;
wire [data_width - 1:0] portbdataout_tmp;

// asynch clear
wire dataout_b_clr_in;
wire dataout_b_clr;

// clocks
assign clk_a_in = clk0;
assign clk_b_out = (port_b_data_out_clock == "clock1") ? clk1 : 1'b0;

// Port A registers
common_porta_registers write_side_registers(
        .addr_d(portaaddr),
        .datain_d(portadatain),
        .byteena_d(portabyteenamasks),
        .clk(clk_a_in),
	.aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena2),
	.stall(1'b0),
        .addr_q(addr_a_reg),
        .datain_q(datain_a_reg),
        .byteena_q(byteena_a_reg)
        );
defparam write_side_registers.addr_register_width = address_width;
defparam write_side_registers.datain_register_width = data_width;
defparam write_side_registers.byteena_register_width = byte_enable_mask_width;
	
// Port B registers
common_28nm_ram_register data_b_register(
        .d(dataout_b),
        .clk(clk_b_out),
	.aclr(dataout_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena1),
	.stall(1'b0),
        .q(dataout_b_reg),
	.aclrout(dataout_b_clr)
        );
defparam data_b_register.width = data_width;

specify
      (portbaddr *> portbdataout) = (0,0);
endspecify

assign portbdataout_tmp = (port_b_data_out_clock == "clock1") ? dataout_b_reg : dataout_b;
assign portbdataout = portbdataout_tmp;
assign dataout_b_clr_in = (port_b_data_out_clear == "clear") ? clr : 1'b0;

// LUTRAM core
common_28nm_mlab_cell_core my_lutram0
(
	.datain_a_reg(datain_a_reg),
	.addr_a_reg(addr_a_reg),
	.byteena_a_reg(byteena_a_reg),
	.portbaddr(portbaddr),
	.clk_a_in(clk_a_in),
	.ena0(ena0),
	.dataout_b(dataout_b)
);
defparam my_lutram0.first_address = first_address;
defparam my_lutram0.last_address = last_address;
defparam my_lutram0.data_width = data_width;
defparam my_lutram0.address_width = address_width;
defparam my_lutram0.byte_enable_mask_width = byte_enable_mask_width;
defparam my_lutram0.mem_init0 = mem_init0;

endmodule // generic_28nm_hp_mlab_cell_impl

//--------------------------------------------------------------------------
// Module Name     : common_porta_registers
// Description     : Implements write side registers for Arria V MLAB cell.
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module common_porta_registers(
        addr_d,
        datain_d,
        byteena_d,
        clk,
	aclr,
        devclrn,
        devpor,
        ena,
	stall,
        addr_q,
        datain_q,
        byteena_q
        );
parameter addr_register_width = 1;
parameter datain_register_width = 1;
parameter byteena_register_width = 1;
	
input [addr_register_width-1:0] addr_d;
input [datain_register_width-1:0] datain_d;
input [byteena_register_width-1:0] byteena_d;
input clk;
input aclr;
input devclrn;
input devpor;
input ena;
input stall;
output [addr_register_width-1:0] addr_q;
output [datain_register_width-1:0] datain_q;
output [byteena_register_width-1:0] byteena_q;

wire addr_aclrout;
wire datain_aclrout;
wire byteena_aclrout;

// address register
common_28nm_ram_register addr_a_register(
        .d(addr_d),
        .clk(clk),
	.aclr(aclr),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena),
	.stall(stall),
        .q(addr_q),
	.aclrout(addr_aclrout)
        );
defparam addr_a_register.width = addr_register_width;

// data register
common_28nm_ram_register datain_a_register(
        .d(datain_d),
        .clk(clk),
	.aclr(aclr),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena),
	.stall(stall),
        .q(datain_q),
	.aclrout(datain_aclrout)
        );
defparam datain_a_register.width = datain_register_width;

// byte enable register
common_28nm_ram_register byteena_a_register(
        .d(byteena_d),
        .clk(clk),
	.aclr(aclr),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena),
	.stall(stall),
        .q(byteena_q),
	.aclrout(byteena_aclrout)
        );
defparam byteena_a_register.width = byteena_register_width;

endmodule

//--------------------------------------------------------------------------
// Module Name     : generic_28nm_lc_mlab_cell_impl
// Description     : Main RAM module
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module generic_28nm_lc_mlab_cell_impl
    (
     portadatain,
     portaaddr, 
     portabyteenamasks, 
     portbaddr,
     clk0, clk1,
     ena0, ena1,
     ena2,
     clr,
     devclrn,
     devpor,
     portbdataout
     );

// -------- PACKAGES ------------------

import altera_lnsim_functions::*;

// -------- GLOBAL PARAMETERS ---------

parameter logical_ram_name = "lutram";

parameter logical_ram_depth = 0;
parameter logical_ram_width = 0;
parameter first_address = 0;
parameter last_address = 0;
parameter first_bit_number = 0;

parameter mixed_port_feed_through_mode = "new";
parameter init_file = "NONE";

parameter data_width = 20;
parameter address_width = 6;
parameter byte_enable_mask_width = 1;
parameter byte_size = 1;
parameter port_b_data_out_clock = "none";
parameter port_b_data_out_clear = "none";

parameter lpm_type = "common_28nm_mlab_cell";
parameter lpm_hint = "true";

parameter mem_init0 = "";

// -------- PORT DECLARATIONS ---------
input [data_width - 1:0] portadatain;
input [address_width - 1:0] portaaddr;
input [byte_enable_mask_width - 1:0] portabyteenamasks;
input [address_width - 1:0] portbaddr;

input clk0;
input clk1;

input ena0;
input ena1;
input ena2;

input clr;

input devclrn;
input devpor;

output [data_width - 1:0] portbdataout;

tri1 devclrn;
tri1 devpor;

tri0 [data_width - 1:0] portadatain;
tri0 [address_width - 1:0] portaaddr;
tri1 [byte_enable_mask_width - 1:0] portabyteenamasks;
tri0 clr;
tri0 clk0,clk1;
tri1 ena0,ena1;
tri1 ena2;

wire clk_a_in;
wire clk_b_out;

// port A registers
wire [address_width - 1:0] addr_a_reg;
wire [data_width - 1:0] datain_a_reg;
wire [byte_enable_mask_width - 1:0] byteena_a_reg;

// port B registers
wire [data_width - 1:0] dataout_b;
wire [data_width - 1:0] dataout_b_reg;
wire [data_width - 1:0] portbdataout_tmp;

// asynch clear
wire dataout_b_clr_in;
wire dataout_b_clr;

// clocks
assign clk_a_in = clk0;
assign clk_b_out = (port_b_data_out_clock == "clock1") ? clk1 : 1'b0;

// Port A registers
common_porta_registers write_side_registers(
        .addr_d(portaaddr),
        .datain_d(portadatain),
        .byteena_d(portabyteenamasks),
        .clk(clk_a_in),
	.aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena2),
	.stall(1'b0),
        .addr_q(addr_a_reg),
        .datain_q(datain_a_reg),
        .byteena_q(byteena_a_reg)
        );
defparam write_side_registers.addr_register_width = address_width;
defparam write_side_registers.datain_register_width = data_width;
defparam write_side_registers.byteena_register_width = byte_enable_mask_width;
	
// Port B registers
common_28nm_ram_register data_b_register(
        .d(dataout_b),
        .clk(clk_b_out),
	.aclr(dataout_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena1),
	.stall(1'b0),
        .q(dataout_b_reg),
	.aclrout(dataout_b_clr)
        );
defparam data_b_register.width = data_width;

specify
      (portbaddr *> portbdataout) = (0,0);
endspecify

assign portbdataout_tmp = (port_b_data_out_clock == "clock1") ? dataout_b_reg : dataout_b;
assign portbdataout = portbdataout_tmp;
assign dataout_b_clr_in = (port_b_data_out_clear == "clear") ? clr : 1'b0;

// LUTRAM core
common_28nm_mlab_cell_core my_lutram0
(
	.datain_a_reg(datain_a_reg),
	.addr_a_reg(addr_a_reg),
	.byteena_a_reg(byteena_a_reg),
	.portbaddr(portbaddr),
	.clk_a_in(clk_a_in),
	.ena0(ena0),
	.dataout_b(dataout_b)
);
defparam my_lutram0.first_address = first_address;
defparam my_lutram0.last_address = last_address;
defparam my_lutram0.data_width = data_width;
defparam my_lutram0.address_width = address_width;
defparam my_lutram0.byte_enable_mask_width = byte_enable_mask_width;
defparam my_lutram0.mem_init0 = mem_init0;

endmodule // generic_28nm_lc_mlab_cell_impl
`timescale 1 ps/1 ps
module generic_mux
(
	input wire [63:0] din,
	input wire [5:0] sel,

	output wire dout
);

	assign dout = din[sel];

endmodule
`timescale 1 ps/1 ps
module generic_device_pll
#(
	parameter reference_clock_frequency = "0 ps",
	parameter output_clock_frequency = "0 ps",
	parameter forcelock = "false",
	parameter nreset_invert = "false",
	parameter pll_enable = "false",
	parameter pll_fbclk_mux_1 = "glb",
	parameter pll_fbclk_mux_2 = "fb_1",
	parameter pll_m_cnt_bypass_en = "false",
	parameter pll_m_cnt_hi_div = 1,
	parameter pll_m_cnt_in_src = "ph_mux_clk",
	parameter pll_m_cnt_lo_div = 1,
	parameter pll_n_cnt_bypass_en = "false",
	parameter pll_n_cnt_hi_div = 1,
	parameter pll_n_cnt_lo_div = 1,
	parameter pll_vco_ph0_en = "false",
	parameter pll_vco_ph1_en = "false",
	parameter pll_vco_ph2_en = "false",
	parameter pll_vco_ph3_en = "false",
	parameter pll_vco_ph4_en = "false",
	parameter pll_vco_ph5_en = "false",
	parameter pll_vco_ph6_en = "false",
	parameter pll_vco_ph7_en = "false"
) (
	input	wire			coreclkfb,
	input	wire			fbclkfpll,
	input	wire			lvdsfbin,
	input	wire			nresync,
	input	wire			pfden,
	input	wire			refclkin,
	input	wire			zdb,

	output	wire			fbclk,
	output	wire			fblvdsout,
	output	wire			lock,
	output	wire	[ 7:0 ]	vcoph
);

	import altera_lnsim_functions::*;

	wire fboutclk_wire;
	wire locked_wire;
	wire nresync_wire;
	wire vcoph_0_wire;
	wire vcoph_1_wire;
	wire vcoph_2_wire;
	wire vcoph_3_wire;

	localparam phase_step = get_time_value(output_clock_frequency) / 8;

	//////////////////////////////////////////////////
	// nresync
	//////////////////////////////////////////////////

	assign nresync_wire = pll_enable == "false" ? 1'b0 : nresync;

	//////////////////////////////////////////////////
	// lock
	//////////////////////////////////////////////////
	
	assign lock = forcelock == "true" ? 1'b1 : locked_wire;

	//////////////////////////////////////////////////
	// fbclk -- SPR 392476: need to return fbclk to higher level
	//////////////////////////////////////////////////
	assign fbclk = fboutclk_wire;

	//////////////////////////////////////////////////
	// vcoph[0]
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift("0 ps")
	) inst_pll_phase_0 (
		.refclk(refclkin),
		.rst(nresync_wire),
		.fbclk(fboutclk_wire),
		
		.outclk(vcoph_0_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	);

	assign vcoph[0] = pll_vco_ph0_en == "true" ? vcoph_0_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[1]
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(get_time_string(phase_step, "ps"))
	) inst_pll_phase_1 (
		.refclk(refclkin),
		.rst(nresync_wire),
		.fbclk(fboutclk_wire),
		
		.outclk(vcoph_1_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	);

	assign vcoph[1] = pll_vco_ph1_en == "true" ? vcoph_1_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[2]
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(get_time_string(phase_step * 2, "ps"))
	) inst_pll_phase_2 (
		.refclk(refclkin),
		.rst(nresync_wire),
		.fbclk(fboutclk_wire),
		
		.outclk(vcoph_2_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	);

	assign vcoph[2] = pll_vco_ph2_en == "true" ? vcoph_2_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[3]
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(get_time_string(phase_step * 3, "ps"))
	) inst_pll_phase_3 (
		.refclk(refclkin),
		.rst(nresync_wire),
		.fbclk(fboutclk_wire),
		
		.outclk(vcoph_3_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire),

                .writerefclkdata(),
                .writeoutclkdata(),
                .writephaseshiftdata(),
                .writedutycycledata(),
                .readrefclkdata(),
                .readoutclkdata(),
                .readphaseshiftdata(),
                .readdutycycledata()
	);

	assign vcoph[3] = pll_vco_ph3_en == "true" ? vcoph_3_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[4]
	//////////////////////////////////////////////////

	assign vcoph[4] = pll_vco_ph4_en == "true" ? !vcoph_0_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[5]
	//////////////////////////////////////////////////

	assign vcoph[5] = pll_vco_ph5_en == "true" ? !vcoph_1_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[6]
	//////////////////////////////////////////////////

	assign vcoph[6] = pll_vco_ph6_en == "true" ? !vcoph_2_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[7]
	//////////////////////////////////////////////////
	
	assign vcoph[7] = pll_vco_ph7_en == "true" ? !vcoph_3_wire : 1'b0;

endmodule

`timescale 1ps/1ps


//--------------------------------------------------------------------------
// Module Name     : altera_mult_add
//
// Description     : Main module for altera_mult_add component
//--------------------------------------------------------------------------
module altera_mult_add (
		dataa, 
		datab,
		datac,
		scanina,
		scaninb,
		sourcea,
		sourceb,
		clock3, 
		clock2, 
		clock1, 
		clock0, 
		aclr3, 
		aclr2, 
		aclr1, 
		aclr0, 
		ena3, 
		ena2, 
		ena1, 
		ena0, 
		signa, 
		signb, 
		addnsub1, 
		addnsub3, 
		result, 
		scanouta, 
		scanoutb,
		mult01_round,
		mult23_round,
		mult01_saturation,
		mult23_saturation,
		addnsub1_round,
		addnsub3_round,
		mult0_is_saturated,
		mult1_is_saturated,
		mult2_is_saturated,
		mult3_is_saturated,
		output_round,
		chainout_round,
		output_saturate,
		chainout_saturate,
		overflow,
		chainout_sat_overflow,
		chainin,
		zero_chainout,
		rotate,
		shift_right,
		zero_loopback,
		accum_sload,
		sload_accum,
		coefsel0,
		coefsel1,
		coefsel2,
		coefsel3
	);

	//==========================================================
	// Altmult_add parameters declaration
	//==========================================================
	// general setting parameters
	parameter extra_latency                   = 0;
	parameter dedicated_multiplier_circuitry  = "AUTO";
	parameter dsp_block_balancing             = "AUTO";
	parameter selected_device_family          = "Stratix V";
	parameter lpm_type                        = "altmult_add";
	parameter lpm_hint                        = "UNUSED";
	
	
	// Input A related parameters
	parameter width_a  = 1;
	
	parameter input_register_a0  = "UNREGISTERED";
	parameter input_aclr_a0      = "NONE";
	parameter input_source_a0    = "DATAA";

	parameter input_register_a1  = "UNREGISTERED";
	parameter input_aclr_a1      = "NONE";
	parameter input_source_a1    = "DATAA";

	parameter input_register_a2  = "UNREGISTERED";
	parameter input_aclr_a2      = "NONE";
	parameter input_source_a2    = "DATAA";

	parameter input_register_a3  = "UNREGISTERED";
	parameter input_aclr_a3      = "NONE";
	parameter input_source_a3    = "DATAA";
	
	
	// Input B related parameters 
	parameter width_b  = 1;
	
	parameter input_register_b0  = "UNREGISTERED";
	parameter input_aclr_b0      = "NONE";
	parameter input_source_b0    = "DATAB";

	parameter input_register_b1  = "UNREGISTERED";
	parameter input_aclr_b1      = "NONE";
	parameter input_source_b1    = "DATAB";

	parameter input_register_b2  = "UNREGISTERED";
	parameter input_aclr_b2      = "NONE";
	parameter input_source_b2    = "DATAB";

	parameter input_register_b3  = "UNREGISTERED";
	parameter input_aclr_b3      = "NONE";
	parameter input_source_b3    = "DATAB";
	
	
	// Input C related parameters 
	parameter width_c  = 1;
	
	parameter input_register_c0  = "UNREGISTERED";
	parameter input_aclr_c0      = "NONE";
	
	parameter input_register_c1  = "UNREGISTERED";
	parameter input_aclr_c1      = "NONE";
	
	parameter input_register_c2  = "UNREGISTERED";
	parameter input_aclr_c2      = "NONE";
	
	parameter input_register_c3  = "UNREGISTERED";
	parameter input_aclr_c3      = "NONE";
	
	
	// Output related parameters
	parameter width_result     = 34;
	parameter output_register  = "UNREGISTERED";
	parameter output_aclr      = "NONE";
	
	
	// Signed related parameters
	parameter port_signa        = "PORT_UNUSED";
	parameter representation_a  = "UNSIGNED";
	
	parameter signed_register_a           = "UNREGISTERED";
	parameter signed_aclr_a               = "NONE";
	parameter signed_pipeline_register_a  = "UNREGISTERED";
	parameter signed_pipeline_aclr_a      = "NONE";
	
	parameter port_signb        = "PORT_UNUSED";
	parameter representation_b  = "UNSIGNED";
	
	parameter signed_register_b           = "UNREGISTERED";
	parameter signed_aclr_b               = "NONE";
	parameter signed_pipeline_register_b  = "UNREGISTERED";
	parameter signed_pipeline_aclr_b      = "NONE";
	
	
	// Multiplier related parameters
	parameter number_of_multipliers  = 1;
	
	parameter multiplier1_direction  = "NONE";
	parameter multiplier3_direction  = "NONE";
	
	parameter multiplier_register0  = "UNREGISTERED";
	parameter multiplier_aclr0     = "NONE";
	parameter multiplier_register1  = "UNREGISTERED";
	parameter multiplier_aclr1      = "NONE";
	parameter multiplier_register2  = "UNREGISTERED";
	parameter multiplier_aclr2      = "NONE";
	parameter multiplier_register3  = "UNREGISTERED";
	parameter multiplier_aclr3      = "NONE";
	
	
	// Adder related parameters
	parameter port_addnsub1                          = "PORT_UNUSED";
	parameter addnsub_multiplier_register1           = "UNREGISTERED";
	parameter addnsub_multiplier_aclr1               = "NONE";
	parameter addnsub_multiplier_pipeline_register1  = "UNREGISTERED";
	parameter addnsub_multiplier_pipeline_aclr1      = "NONE";
   
	parameter port_addnsub3                          = "PORT_UNUSED";
	parameter addnsub_multiplier_register3           = "UNREGISTERED";
	parameter addnsub_multiplier_aclr3               = "NONE";
	parameter addnsub_multiplier_pipeline_register3  = "UNREGISTERED";
	parameter addnsub_multiplier_pipeline_aclr3      = "NONE";

	
	// Rounding related parameters
	parameter adder1_rounding                   = "NO";
	parameter addnsub1_round_register           = "UNREGISTERED";
	parameter addnsub1_round_aclr               = "NONE";
	parameter addnsub1_round_pipeline_register  = "UNREGISTERED";
	parameter addnsub1_round_pipeline_aclr      = "NONE";
	
	parameter adder3_rounding                   = "NO";
	parameter addnsub3_round_register           = "UNREGISTERED";
	parameter addnsub3_round_aclr               = "NONE";
	parameter addnsub3_round_pipeline_register  = "UNREGISTERED";
	parameter addnsub3_round_pipeline_aclr		  = "NONE";
	
	parameter multiplier01_rounding  = "NO";
	parameter mult01_round_register  = "UNREGISTERED";
	parameter mult01_round_aclr      = "NONE";
	
	parameter multiplier23_rounding  = "NO";
	parameter mult23_round_register  = "UNREGISTERED";
	parameter mult23_round_aclr      = "NONE";
	
	parameter width_msb                       = 17;
	
	parameter output_rounding                 = "NO";
	parameter output_round_type               = "NEAREST_INTEGER";
	parameter output_round_register           = "UNREGISTERED";
	parameter output_round_aclr               = "NONE";
	parameter output_round_pipeline_register  = "UNREGISTERED";
	parameter output_round_pipeline_aclr      = "NONE";
	
	parameter chainout_rounding                 = "NO";
	parameter chainout_round_register           = "UNREGISTERED";
	parameter chainout_round_aclr               = "NONE";
	parameter chainout_round_pipeline_register  = "UNREGISTERED";
	parameter chainout_round_pipeline_aclr      = "NONE";
	parameter chainout_round_output_register    = "UNREGISTERED";
	parameter chainout_round_output_aclr        = "NONE";
	
	
	// Saturation related parameters
	parameter multiplier01_saturation     = "NO";
	parameter mult01_saturation_register  = "UNREGISTERED";
	parameter mult01_saturation_aclr      = "NONE";
	
	parameter multiplier23_saturation     = "NO";
	parameter mult23_saturation_register  = "UNREGISTERED";
	parameter mult23_saturation_aclr      = "NONE";
	
	parameter port_mult0_is_saturated  = "NONE";
	parameter port_mult1_is_saturated  = "NONE";
	parameter port_mult2_is_saturated  = "NONE";
	parameter port_mult3_is_saturated  = "NONE";
	
	parameter width_saturate_sign = 1;
	
	parameter output_saturation                  = "NO";
	parameter port_output_is_overflow            = "PORT_UNUSED";
	parameter output_saturate_type               = "ASYMMETRIC";
	parameter output_saturate_register           = "UNREGISTERED";
	parameter output_saturate_aclr               = "NONE";
	parameter output_saturate_pipeline_register  = "UNREGISTERED";
	parameter output_saturate_pipeline_aclr      = "NONE";
	
	parameter chainout_saturation                  = "NO";
	parameter port_chainout_sat_is_overflow        = "PORT_UNUSED";
	parameter chainout_saturate_register           = "UNREGISTERED";
	parameter chainout_saturate_aclr               = "NONE";
	parameter chainout_saturate_pipeline_register  = "UNREGISTERED";
	parameter chainout_saturate_pipeline_aclr      = "NONE";
	parameter chainout_saturate_output_register    = "UNREGISTERED";
	parameter chainout_saturate_output_aclr        = "NONE";
	
	
	// Scanchain related parameters
	parameter scanouta_register  = "UNREGISTERED";
	parameter scanouta_aclr      = "NONE";
	
	
	// Chain (chainin and chainout) related parameters
	parameter width_chainin  = 1;
	
	parameter chainout_adder     = "NO";
	parameter chainout_register  = "UNREGISTERED";
	parameter chainout_aclr      = "NONE";
	
	parameter zero_chainout_output_register  = "UNREGISTERED";
	parameter zero_chainout_output_aclr      = "NONE";
	
	
	// Rotate & shift related parameters
	parameter shift_mode  = "NO";
	
	parameter rotate_register           = "UNREGISTERED";
	parameter rotate_aclr               = "NONE";
	parameter rotate_pipeline_register  = "UNREGISTERED";
	parameter rotate_pipeline_aclr      = "NONE";
	parameter rotate_output_register    = "UNREGISTERED";
	parameter rotate_output_aclr        = "NONE";
	
	parameter shift_right_register           = "UNREGISTERED";
	parameter shift_right_aclr               = "NONE";
	parameter shift_right_pipeline_register  = "UNREGISTERED";
	parameter shift_right_pipeline_aclr      = "NONE";
	parameter shift_right_output_register    = "UNREGISTERED";
	parameter shift_right_output_aclr        = "NONE";
	
	
	// Loopback related parameters
	parameter zero_loopback_register           = "UNREGISTERED";
	parameter zero_loopback_aclr               = "NONE";
	parameter zero_loopback_pipeline_register  = "UNREGISTERED";
	parameter zero_loopback_pipeline_aclr      = "NONE";
	parameter zero_loopback_output_register    = "UNREGISTERED";
	parameter zero_loopback_output_aclr        = "NONE";
	
	
	// Accumulator and loadconst related parameters
	parameter accumulator      = "NO";
	parameter accum_direction  = "ADD";
	parameter loadconst_value = 0;
	parameter use_sload_accum_port 	= "NO";
	
	parameter accum_sload_register           = "UNREGISTERED";
	parameter accum_sload_aclr               = "NONE";
	parameter accum_sload_pipeline_register  = "UNREGISTERED";
	parameter accum_sload_pipeline_aclr      = "NONE";
	
	parameter loadconst_control_register = "UNREGISTERED";
	parameter loadconst_control_aclr	 = "NONE";
	
	parameter double_accum      = "NO";
	
	// Systolic related parameters
	parameter systolic_delay1 = "UNREGISTERED";
	parameter systolic_delay3 = "UNREGISTERED";
	parameter systolic_aclr1 = "NONE";
	parameter systolic_aclr3 = "NONE";
	
	// Preadder related parameters
	parameter preadder_mode  = "SIMPLE";
	
	parameter preadder_direction_0  = "ADD";
	parameter preadder_direction_1  = "ADD";
	parameter preadder_direction_2  = "ADD";
	parameter preadder_direction_3  = "ADD";
	
	parameter width_coef  = 1;
	
	parameter coefsel0_register  = "UNREGISTERED";
	parameter coefsel0_aclr	     = "NONE";
	parameter coefsel1_register  = "UNREGISTERED";
	parameter coefsel1_aclr	     = "NONE";
	parameter coefsel2_register  = "UNREGISTERED";
	parameter coefsel2_aclr	     = "NONE";
	parameter coefsel3_register  = "UNREGISTERED";
	parameter coefsel3_aclr	     = "NONE";

	parameter coef0_0  = 0;
	parameter coef0_1  = 0;
	parameter coef0_2  = 0;
	parameter coef0_3  = 0;
	parameter coef0_4  = 0;
	parameter coef0_5  = 0;
	parameter coef0_6  = 0;
	parameter coef0_7  = 0;

	parameter coef1_0  = 0;
	parameter coef1_1  = 0;
	parameter coef1_2  = 0;
	parameter coef1_3  = 0;
	parameter coef1_4  = 0;
	parameter coef1_5  = 0;
	parameter coef1_6  = 0;
	parameter coef1_7  = 0;

	parameter coef2_0  = 0;
	parameter coef2_1  = 0;
	parameter coef2_2  = 0;
	parameter coef2_3  = 0;
	parameter coef2_4  = 0;
	parameter coef2_5  = 0;
	parameter coef2_6  = 0;
	parameter coef2_7  = 0;

	parameter coef3_0  = 0;
	parameter coef3_1  = 0;
	parameter coef3_2  = 0;
	parameter coef3_3  = 0;
	parameter coef3_4  = 0;
	parameter coef3_5  = 0;
	parameter coef3_6  = 0;
	parameter coef3_7  = 0;

	//==========================================================
	// Internal parameters declaration
	//==========================================================
	// Width related parameters
		// Register related width parameters
		parameter width_clock_all_wire_msb = 3;   // Clock wire total width
		parameter width_aclr_all_wire_msb = 3;    // Aclr wire total width
		parameter width_ena_all_wire_msb = 3;     // Clock enable wire total width
		
		// Data input width related parameters
		parameter width_a_total_msb  = (width_a * number_of_multipliers) - 1;   // Total width of dataa input
		parameter width_a_msb  = width_a - 1;     // MSB for splited dataa width
		
		parameter width_b_total_msb  = (width_b * number_of_multipliers) - 1;   // Total width of data input
		parameter width_b_msb  = width_b - 1;     // MSB for splited datab width
		
		parameter width_c_total_msb  = (width_c * number_of_multipliers) - 1;   // Total width of datac input
		parameter width_c_msb  = width_c - 1;     // MSB for splited datac width

		// Scanchain width related parameters
		parameter width_scanina = width_a;                  // Width for scanina port
		parameter width_scanina_msb = width_scanina - 1;    // MSB for scanina port
		
		parameter width_scaninb = width_b;                  // Width for scaninb port
		parameter width_scaninb_msb = width_scaninb - 1;    // MSB for scaninb port
		
		parameter width_sourcea_msb = number_of_multipliers -1;    // MSB for sourcea port
		parameter width_sourceb_msb = number_of_multipliers -1;    // MSB for sourceb port
		
		parameter width_scanouta_msb = width_a -1;    // MSB for scanouta port
		parameter width_scanoutb_msb = width_b -1;    // MSB for scanoutb port

		// chain (chainin and chainout) width related parameters
		parameter width_chainin_msb = width_chainin - 1;    // MSB for chainin port
		
		// Result width related parameters
		parameter width_result_msb = width_result - 1;      // MSB for result port
		
		// Coef width related parameters
		parameter width_coef_msb = width_coef -1;           // MSB for selected coef output
	
	
	// Internal width related parameters
		// Input data width related parameters
		parameter dataa_split_ext_require = (port_signa === "PORT_USED") ? 1 : 0;        // Determine dynamic sign extension 
		parameter dataa_port_sign = port_signa;                                          // Dynamic sign port for dataa
		parameter width_a_ext = (dataa_split_ext_require == 1) ? width_a + 1 : width_a ; // Sign extension when require
		parameter width_a_ext_msb = width_a_ext - 1;                                     // MSB for dataa
		
		parameter datab_split_ext_require = (preadder_mode === "SIMPLE") ? ((port_signb === "PORT_USED") ? 1 : 0):
		                                                                   ((port_signa === "PORT_USED") ? 1 : 0) ;   // Determine dynamic sign extension 
		parameter datab_port_sign = (preadder_mode === "SIMPLE") ? port_signb : port_signa;    // Dynamic sign port for dataa
		parameter width_b_ext = (datab_split_ext_require == 1) ? width_b + 1 : width_b;        // Sign extension when require
		parameter width_b_ext_msb = width_b_ext - 1;                                           // MSB for datab
		
		parameter coef_ext_require = (port_signb === "PORT_USED") ? 1 : 0;                // Determine dynamic sign extension 
		parameter coef_port_sign  = port_signb;                                           // Dynamic sign port for coef
		parameter width_coef_ext = (coef_ext_require == 1) ? width_coef + 1 : width_coef; // Sign extension when require
		parameter width_coef_ext_msb = width_coef_ext - 1;                                // MSB for coef
		
		parameter datac_split_ext_require = (port_signb === "PORT_USED") ? 1 : 0;        // Determine dynamic sign extension 
		parameter datac_port_sign = port_signb;                                          // Dynamic sign port for datac
		parameter width_c_ext = (datac_split_ext_require == 1) ? width_c + 1 : width_c;  // Sign extension when require
		parameter width_c_ext_msb = width_c_ext - 1;                                     // MSB for datac
		
		
		// Scanchain width related parameters
		parameter width_scanchain = (port_signa === "PORT_USED") ? width_scanina + 1 : width_scanina;  // Sign extension when require
		parameter width_scanchain_msb = width_scanchain - 1;
		parameter scanchain_port_sign = port_signa;                                      // Dynamic sign port for scanchain
		
		
		// Preadder width related parameters
		parameter preadder_representation = (port_signa === "PORT_USED") ? "SIGNED" : representation_a;   // Representation for preadder adder
		
		parameter width_preadder_input_a = (input_source_a0 === "SCANA")? width_scanchain : width_a_ext;   // Preadder input a selection width
		parameter width_preadder_input_a_msb = width_preadder_input_a - 1;                                      // MSB for preadder input a
		
		parameter width_preadder_adder_result = (width_preadder_input_a > width_b_ext)? width_preadder_input_a + 1 : width_b_ext + 1; // Adder extension by one for the largest width
		
		parameter width_preadder_output_a = (preadder_mode === "INPUT" || preadder_mode === "SQUARE" || preadder_mode === "COEF")? width_preadder_adder_result:
		                                     width_preadder_input_a;              // Preadder first output width
		parameter width_preadder_output_a_msb = width_preadder_output_a - 1;      // MSB for preadder first output width
		
		parameter width_preadder_output_b = (preadder_mode === "INPUT")? width_c_ext :
		                                    (preadder_mode === "SQUARE")? width_preadder_adder_result :
		                                    (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? width_coef_ext :
														width_b_ext;                         // Preadder second output width
		parameter width_preadder_output_b_msb = width_preadder_output_b - 1;     // MSB for preadder second output width
		
		
		// Multiplier width related parameters
		parameter multiplier_input_representation_a = (port_signa === "PORT_USED") ? "SIGNED" : representation_a;   // Representation for multiplier first input
		parameter multiplier_input_representation_b = (preadder_mode === "SQUARE") ? multiplier_input_representation_a :
		                                              (port_signb === "PORT_USED") ? "SIGNED" : representation_b;   // Representation for multiplier second input
		
		parameter width_mult_source_a = width_preadder_output_a;        // Multiplier first input width
		parameter width_mult_source_a_msb = width_mult_source_a - 1;    // MSB for multiplier first input width
		
		parameter width_mult_source_b = width_preadder_output_b;        // Multiplier second input width
		parameter width_mult_source_b_msb = width_mult_source_b - 1;    // MSB for multiplier second input width
		
		parameter width_mult_result = width_mult_source_a + width_mult_source_b +
		                              ((multiplier_input_representation_a === "UNSIGNED") ? 1 : 0) +
		                              ((multiplier_input_representation_b === "UNSIGNED") ? 1 : 0);   // Multiplier result width
		parameter width_mult_result_msb = width_mult_result -1;                                       // MSB for multiplier result width
		
		
		// Adder width related parameters
		parameter width_adder_source = width_mult_result;             // Final adder or systolic adder source width
		parameter width_adder_source_msb = width_adder_source - 1;    // MSB for adder source width
		
		parameter width_adder_result = width_adder_source + ((number_of_multipliers <= 2)? 1 : 2);  // Adder extension (2 when excute two level adder, else 1) and sign extension
		parameter width_adder_result_msb = width_adder_result - 1;                                  // MSB for adder result
		
		
		// Chainout adder width related parameters
		parameter width_chainin_ext = width_result - width_chainin;
		
		// Original output width related parameters
		parameter width_original_result = width_adder_result;               // The original result width without truncated
		parameter width_original_result_msb = width_original_result - 1;    // The MSB for original result 
		
		// Output width related parameters
		parameter result_ext_width    = (width_result_msb > width_original_result_msb) ? width_result_msb - width_original_result_msb : 1;   // Width that require to extend
		
		parameter width_result_output = (width_result_msb > width_original_result_msb) ? width_result : width_original_result + 1;   // Output width that ready for truncated
		parameter width_result_output_msb = width_result_output - 1;    // MSB for output width that ready for truncated
		
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input related ports
	input [width_a_total_msb : 0] dataa;
	input [width_b_total_msb : 0] datab;
	input [width_c_total_msb : 0] datac;
	
	// Scanchain related ports
	input [width_scanina_msb : 0] scanina;
	input [width_scaninb_msb : 0] scaninb;
	input [width_sourcea_msb : 0] sourcea;
	input [width_sourceb_msb : 0] sourceb;
	
	output [width_scanouta_msb : 0] scanouta;
	output [width_scanoutb_msb : 0] scanoutb;
	
	// Clock related ports
	input clock0, clock1, clock2, clock3;
	
	// Clear related ports
	input aclr0, aclr1, aclr2, aclr3;
	
	// Clock enable related ports
	input ena0, ena1, ena2, ena3;
	
	// Signals control related ports
	input signa, signb;
	input addnsub1, addnsub3;
	
	// Rounding related ports
	input mult01_round, mult23_round;
	input addnsub1_round, addnsub3_round;
	input output_round;
	input chainout_round;
	
	// Saturation related ports
	input mult01_saturation, mult23_saturation;
	input output_saturate;
	input chainout_saturate;
	
	output mult0_is_saturated, mult1_is_saturated, mult2_is_saturated, mult3_is_saturated;
	output chainout_sat_overflow;
	
	// chain (chainin and chainout) related port
	input [width_chainin_msb : 0] chainin;
	input zero_chainout;
	
	// Rotate & shift related port
	input rotate;
	input shift_right;
	
	// Loopback related port
	input zero_loopback;
	
	// Accumulator related port
	input accum_sload;
	input sload_accum;	
	
	// Preadder related port
	input [2 : 0] coefsel0, coefsel1, coefsel2, coefsel3;
	
	// Output related port
	output [width_result_msb : 0] result;
	output overflow;
	
altera_mult_add_rtl #(
	.extra_latency(extra_latency),
	.dedicated_multiplier_circuitry(dedicated_multiplier_circuitry),
	.dsp_block_balancing(dsp_block_balancing),
	.selected_device_family(selected_device_family),
	.lpm_type(lpm_type),
	.lpm_hint(lpm_hint),
	.width_a(width_a),
	.input_register_a0(input_register_a0),
	.input_aclr_a0(input_aclr_a0),
	.input_source_a0(input_source_a0),
	.input_register_a1(input_register_a1),
	.input_aclr_a1(input_aclr_a1),
	.input_source_a1(input_source_a1),
	.input_register_a2(input_register_a2),
	.input_aclr_a2(input_aclr_a2),
	.input_source_a2(input_source_a2),
	.input_register_a3(input_register_a3),
	.input_aclr_a3(input_aclr_a3),
	.input_source_a3(input_source_a3),
	.width_b(width_b),
	.input_register_b0(input_register_b0),
	.input_aclr_b0(input_aclr_b0),
	.input_source_b0(input_source_b0),
	.input_register_b1(input_register_b1),
	.input_aclr_b1(input_aclr_b1),
	.input_source_b1(input_source_b1),
	.input_register_b2(input_register_b2),
	.input_aclr_b2(input_aclr_b2),
	.input_source_b2(input_source_b2),
	.input_register_b3(input_register_b3),
	.input_aclr_b3(input_aclr_b3),
	.input_source_b3(input_source_b3),
	.width_c(width_c),
	.input_register_c0(input_register_c0),
	.input_aclr_c0(input_aclr_c0),
	.input_register_c1(input_register_c1),
	.input_aclr_c1(input_aclr_c1),
	.input_register_c2(input_register_c2),
	.input_aclr_c2(input_aclr_c2),
	.input_register_c3(input_register_c3),
	.input_aclr_c3(input_aclr_c3),
	.width_result(width_result),
	.output_register(output_register),
	.output_aclr(output_aclr),
	.port_signa(port_signa),
	.representation_a(representation_a),
	.signed_register_a(signed_register_a),
	.signed_aclr_a(signed_aclr_a),
	.signed_pipeline_register_a(signed_pipeline_register_a),
	.signed_pipeline_aclr_a(signed_pipeline_aclr_a),
	.port_signb(port_signb),
	.representation_b(representation_b),
	.signed_register_b(signed_register_b),
	.signed_aclr_b(signed_aclr_b),
	.signed_pipeline_register_b(signed_pipeline_register_b),
	.signed_pipeline_aclr_b(signed_pipeline_aclr_b),
	.number_of_multipliers(number_of_multipliers),
	.multiplier1_direction(multiplier1_direction),
	.multiplier3_direction(multiplier3_direction),
	.multiplier_register0(multiplier_register0),	
	.multiplier_aclr0(multiplier_aclr0),
	.multiplier_register1(multiplier_register1),
	.multiplier_aclr1(multiplier_aclr1),
	.multiplier_register2(multiplier_register2),
	.multiplier_aclr2(multiplier_aclr2),
	.multiplier_register3(multiplier_register3),
	.multiplier_aclr3(multiplier_aclr3),
	.port_addnsub1(port_addnsub1),
	.addnsub_multiplier_register1 (addnsub_multiplier_register1),
	.addnsub_multiplier_aclr1(addnsub_multiplier_aclr1),
	.addnsub_multiplier_pipeline_register1(addnsub_multiplier_pipeline_register1),
	.addnsub_multiplier_pipeline_aclr1(addnsub_multiplier_pipeline_aclr1),
	.port_addnsub3(port_addnsub3),
	.addnsub_multiplier_register3(addnsub_multiplier_register3),
	.addnsub_multiplier_aclr3(addnsub_multiplier_aclr3),
	.addnsub_multiplier_pipeline_register3(addnsub_multiplier_pipeline_register3),
	.addnsub_multiplier_pipeline_aclr3(addnsub_multiplier_pipeline_aclr3),
	.adder1_rounding(adder1_rounding),
	.addnsub1_round_register(addnsub1_round_register),
	.addnsub1_round_aclr(addnsub1_round_aclr),
	.addnsub1_round_pipeline_register(addnsub1_round_pipeline_register),
	.addnsub1_round_pipeline_aclr(addnsub1_round_pipeline_aclr),	
	.adder3_rounding(adder3_rounding),
	.addnsub3_round_register(addnsub3_round_register),
	.addnsub3_round_aclr(addnsub3_round_aclr),
	.addnsub3_round_pipeline_register(addnsub3_round_pipeline_register),
	.addnsub3_round_pipeline_aclr(addnsub3_round_pipeline_aclr),
	.multiplier01_rounding(multiplier01_rounding),
	.mult01_round_register(mult01_round_register),
	.mult01_round_aclr(mult01_round_aclr),
	.multiplier23_rounding(multiplier23_rounding),
	.mult23_round_register(mult23_round_register),
	.mult23_round_aclr(mult23_round_aclr),
	.width_msb(width_msb),	
	.output_rounding(output_rounding),
	.output_round_type(output_round_type),
	.output_round_register(output_round_register),
	.output_round_aclr(output_round_aclr),
	.output_round_pipeline_register(output_round_pipeline_register),
	.output_round_pipeline_aclr(output_round_pipeline_aclr),
	.chainout_rounding(chainout_rounding),
	.chainout_round_register(chainout_round_register),
	.chainout_round_aclr(chainout_round_aclr),
	.chainout_round_pipeline_register(chainout_round_pipeline_register),
	.chainout_round_pipeline_aclr(chainout_round_pipeline_aclr),
	.chainout_round_output_register (chainout_round_output_register),
	.chainout_round_output_aclr (chainout_round_output_aclr),
	.multiplier01_saturation(multiplier01_saturation),
	.mult01_saturation_register(mult01_saturation_register),
	.mult01_saturation_aclr(mult01_saturation_aclr),
	.multiplier23_saturation(multiplier23_saturation),
	.mult23_saturation_register(mult23_saturation_register),
	.mult23_saturation_aclr(mult23_saturation_aclr),
	.port_mult0_is_saturated(port_mult0_is_saturated),
	.port_mult1_is_saturated(port_mult1_is_saturated),
	.port_mult2_is_saturated(port_mult2_is_saturated),
	.port_mult3_is_saturated(port_mult3_is_saturated),
	.width_saturate_sign(width_saturate_sign),	
	.output_saturation(output_saturation),
	.port_output_is_overflow(port_output_is_overflow),
	.output_saturate_type(output_saturate_type),
	.output_saturate_register(output_saturate_register),
	.output_saturate_aclr(output_saturate_aclr),
	.output_saturate_pipeline_register(output_saturate_pipeline_register),
	.output_saturate_pipeline_aclr(output_saturate_pipeline_aclr),
	.chainout_saturation(chainout_saturation),
	.port_chainout_sat_is_overflow(port_chainout_sat_is_overflow),
	.chainout_saturate_register(chainout_saturate_register),
	.chainout_saturate_aclr(chainout_saturate_aclr),
	.chainout_saturate_pipeline_register(chainout_saturate_pipeline_register),
	.chainout_saturate_pipeline_aclr(chainout_saturate_pipeline_aclr),
	.chainout_saturate_output_register(chainout_saturate_output_register),
	.chainout_saturate_output_aclr(chainout_saturate_output_aclr),
	.scanouta_register(scanouta_register),
	.scanouta_aclr(scanouta_aclr),
	.width_chainin(width_chainin),
	.chainout_adder(chainout_adder),
	.chainout_register(chainout_register),
	.chainout_aclr(chainout_aclr),	
	.zero_chainout_output_register(zero_chainout_output_register),
	.zero_chainout_output_aclr(zero_chainout_output_aclr),
	.shift_mode(shift_mode),
	.rotate_register(rotate_register),
	.rotate_aclr(rotate_aclr),
	.rotate_pipeline_register(rotate_pipeline_register),
	.rotate_pipeline_aclr(rotate_pipeline_aclr),
	.rotate_output_register(rotate_output_register),
	.rotate_output_aclr(rotate_output_aclr),
	.shift_right_register(shift_right_register),
	.shift_right_aclr(shift_right_aclr),
	.shift_right_pipeline_register(shift_right_pipeline_register),
	.shift_right_pipeline_aclr(shift_right_pipeline_aclr),
	.shift_right_output_register  (shift_right_output_register),
	.shift_right_output_aclr(shift_right_output_aclr),
	.zero_loopback_register(zero_loopback_register),
	.zero_loopback_aclr(zero_loopback_aclr),
	.zero_loopback_pipeline_register(zero_loopback_pipeline_register),
	.zero_loopback_pipeline_aclr(zero_loopback_pipeline_aclr),
	.zero_loopback_output_register(zero_loopback_output_register),
	.zero_loopback_output_aclr(zero_loopback_output_aclr),
	.accumulator(accumulator),
	.accum_direction(accum_direction),
	.loadconst_value (loadconst_value),
	.use_sload_accum_port (use_sload_accum_port),
	.accum_sload_register(accum_sload_register),
	.accum_sload_aclr (accum_sload_aclr),
	.accum_sload_pipeline_register(accum_sload_pipeline_register),
	.accum_sload_pipeline_aclr(accum_sload_pipeline_aclr),
	.loadconst_control_register(loadconst_control_register),
	.loadconst_control_aclr(loadconst_control_aclr),
	.double_accum(double_accum),
	.systolic_delay1(systolic_delay1),
	.systolic_delay3(systolic_delay3),
	.systolic_aclr1(systolic_aclr1),
	.systolic_aclr3(systolic_aclr3),
	.preadder_mode(preadder_mode),
	.preadder_direction_0(preadder_direction_0),
	.preadder_direction_1(preadder_direction_1),
	.preadder_direction_2(preadder_direction_2),
	.preadder_direction_3(preadder_direction_3),
	.width_coef(width_coef),
	.coefsel0_register(coefsel0_register),
	.coefsel0_aclr(coefsel0_aclr),
	.coefsel1_register(coefsel1_register),
	.coefsel1_aclr(coefsel1_aclr),
	.coefsel2_register(coefsel2_register),
	.coefsel2_aclr(coefsel2_aclr),
	.coefsel3_register(coefsel3_register),
	.coefsel3_aclr(coefsel3_aclr),
	.coef0_0  (coef0_0),
	.coef0_1  (coef0_1),
	.coef0_2  (coef0_2),
	.coef0_3  (coef0_3),
	.coef0_4  (coef0_4),
	.coef0_5  (coef0_5),
	.coef0_6  (coef0_6),
	.coef0_7  (coef0_7),
	.coef1_0  (coef1_0),
	.coef1_1  (coef1_1),
	.coef1_2  (coef1_2),
	.coef1_3  (coef1_3),
	.coef1_4  (coef1_4),
	.coef1_5  (coef1_5),
	.coef1_6  (coef1_6),
	.coef1_7  (coef1_7),
	.coef2_0  (coef2_0),
	.coef2_1  (coef2_1),
	.coef2_2  (coef2_2),
	.coef2_3  (coef2_3),
	.coef2_4  (coef2_4),
	.coef2_5  (coef2_5),
	.coef2_6  (coef2_6),
	.coef2_7  (coef2_7),
	.coef3_0  (coef3_0),
	.coef3_1  (coef3_1),
	.coef3_2  (coef3_2),
	.coef3_3  (coef3_3),
	.coef3_4  (coef3_4),
	.coef3_5  (coef3_5),
	.coef3_6  (coef3_6),
	.coef3_7  (coef3_7))
multiply_adder (
	.dataa(dataa), 
	.datab(datab),
	.datac(datac),
	.scanina(scanina),
	.scaninb(scaninb),
	.sourcea(sourcea),
	.sourceb(sourceb),
	.clock3(clock3), 
	.clock2(clock2), 
	.clock1(clock1), 
	.clock0(clock0), 
	.aclr3(aclr3), 
	.aclr2(aclr2), 
	.aclr1(aclr1), 
	.aclr0(aclr0), 
	.ena3(ena3), 
	.ena2(ena2), 
	.ena1(ena1), 
	.ena0(ena0), 
	.signa(signa), 
	.signb(signb), 
	.addnsub1(addnsub1), 
	.addnsub3(addnsub3), 
	.result(result), 
	.scanouta(scanouta), 
	.scanoutb(scanoutb),
	.mult01_round(mult01_round),
	.mult23_round(mult23_round),
	.mult01_saturation(mult01_saturation),
	.mult23_saturation(mult23_saturation),
	.addnsub1_round(addnsub1_round),
	.addnsub3_round(addnsub3_round),
	.mult0_is_saturated(mult0_is_saturated),
	.mult1_is_saturated(mult1_is_saturated),
	.mult2_is_saturated(mult2_is_saturated),
	.mult3_is_saturated(mult3_is_saturated),
	.output_round(output_round),
	.chainout_round(chainout_round),
	.output_saturate(output_saturate),
	.chainout_saturate(chainout_saturate),
	.overflow(overflow),
	.chainout_sat_overflow(chainout_sat_overflow),
	.chainin(chainin),
	.zero_chainout(zero_chainout),
	.rotate(rotate),
	.shift_right(shift_right),
	.zero_loopback(zero_loopback),
	.accum_sload(accum_sload),
	.sload_accum(sload_accum),
	.coefsel0(coefsel0),
	.coefsel1(coefsel1),
	.coefsel2(coefsel2),
	.coefsel3(coefsel3));

	
endmodule
`timescale 1ps/1ps


//--------------------------------------------------------------------------
// Module Name     : altera_mult_add_rtl
//
// Description     : Main module for altera_mult_add_rtl component
//--------------------------------------------------------------------------
module altera_mult_add_rtl (
		dataa, 
		datab,
		datac,
		scanina,
		scaninb,
		sourcea,
		sourceb,
		clock3, 
		clock2, 
		clock1, 
		clock0, 
		aclr3, 
		aclr2, 
		aclr1, 
		aclr0, 
		ena3, 
		ena2, 
		ena1, 
		ena0, 
		signa, 
		signb, 
		addnsub1, 
		addnsub3, 
		result, 
		scanouta, 
		scanoutb,
		mult01_round,
		mult23_round,
		mult01_saturation,
		mult23_saturation,
		addnsub1_round,
		addnsub3_round,
		mult0_is_saturated,
		mult1_is_saturated,
		mult2_is_saturated,
		mult3_is_saturated,
		output_round,
		chainout_round,
		output_saturate,
		chainout_saturate,
		overflow,
		chainout_sat_overflow,
		chainin,
		zero_chainout,
		rotate,
		shift_right,
		zero_loopback,
		accum_sload,
		sload_accum,
		coefsel0,
		coefsel1,
		coefsel2,
		coefsel3
	);

	//==========================================================
	// Altmult_add parameters declaration
	//==========================================================
	// general setting parameters
	parameter extra_latency                   = 0;
	parameter dedicated_multiplier_circuitry  = "AUTO";
	parameter dsp_block_balancing             = "AUTO";
	parameter selected_device_family          = "Stratix V";
	parameter lpm_type                        = "altmult_add";
	parameter lpm_hint                        = "UNUSED";
	
	
	// Input A related parameters
	parameter width_a  = 1;
	
	parameter input_register_a0  = "UNREGISTERED";
	parameter input_aclr_a0      = "NONE";
	parameter input_source_a0    = "DATAA";

	parameter input_register_a1  = "UNREGISTERED";
	parameter input_aclr_a1      = "NONE";
	parameter input_source_a1    = "DATAA";

	parameter input_register_a2  = "UNREGISTERED";
	parameter input_aclr_a2      = "NONE";
	parameter input_source_a2    = "DATAA";

	parameter input_register_a3  = "UNREGISTERED";
	parameter input_aclr_a3      = "NONE";
	parameter input_source_a3    = "DATAA";
	
	
	// Input B related parameters 
	parameter width_b  = 1;
	
	parameter input_register_b0  = "UNREGISTERED";
	parameter input_aclr_b0      = "NONE";
	parameter input_source_b0    = "DATAB";

	parameter input_register_b1  = "UNREGISTERED";
	parameter input_aclr_b1      = "NONE";
	parameter input_source_b1    = "DATAB";

	parameter input_register_b2  = "UNREGISTERED";
	parameter input_aclr_b2      = "NONE";
	parameter input_source_b2    = "DATAB";

	parameter input_register_b3  = "UNREGISTERED";
	parameter input_aclr_b3      = "NONE";
	parameter input_source_b3    = "DATAB";
	
	
	// Input C related parameters 
	parameter width_c  = 1;
	
	parameter input_register_c0  = "UNREGISTERED";
	parameter input_aclr_c0      = "NONE";
	
	parameter input_register_c1  = "UNREGISTERED";
	parameter input_aclr_c1      = "NONE";
	
	parameter input_register_c2  = "UNREGISTERED";
	parameter input_aclr_c2      = "NONE";
	
	parameter input_register_c3  = "UNREGISTERED";
	parameter input_aclr_c3      = "NONE";
	
	
	// Output related parameters
	parameter width_result     = 34;
	parameter output_register  = "UNREGISTERED";
	parameter output_aclr      = "NONE";
	
	
	// Signed related parameters
	parameter port_signa        = "PORT_UNUSED";
	parameter representation_a  = "UNSIGNED";
	
	parameter signed_register_a           = "UNREGISTERED";
	parameter signed_aclr_a               = "NONE";
	parameter signed_pipeline_register_a  = "UNREGISTERED";
	parameter signed_pipeline_aclr_a      = "NONE";
	
	parameter port_signb        = "PORT_UNUSED";
	parameter representation_b  = "UNSIGNED";
	
	parameter signed_register_b           = "UNREGISTERED";
	parameter signed_aclr_b               = "NONE";
	parameter signed_pipeline_register_b  = "UNREGISTERED";
	parameter signed_pipeline_aclr_b      = "NONE";
	
	
	// Multiplier related parameters
	parameter number_of_multipliers  = 1;
	
	parameter multiplier1_direction  = "NONE";
	parameter multiplier3_direction  = "NONE";
	
	parameter multiplier_register0  = "UNREGISTERED";
	parameter multiplier_aclr0      = "NONE";
	parameter multiplier_register1  = "UNREGISTERED";
	parameter multiplier_aclr1      = "NONE";
	parameter multiplier_register2  = "UNREGISTERED";
	parameter multiplier_aclr2      = "NONE";
	parameter multiplier_register3  = "UNREGISTERED";
	parameter multiplier_aclr3      = "NONE";
	
	
	// Adder related parameters
	parameter port_addnsub1                          = "PORT_UNUSED";
	parameter addnsub_multiplier_register1           = "UNREGISTERED";
	parameter addnsub_multiplier_aclr1               = "NONE";
	parameter addnsub_multiplier_pipeline_register1  = "UNREGISTERED";
	parameter addnsub_multiplier_pipeline_aclr1      = "NONE";
   
	parameter port_addnsub3                          = "PORT_UNUSED";
	parameter addnsub_multiplier_register3           = "UNREGISTERED";
	parameter addnsub_multiplier_aclr3	             = "NONE";
	parameter addnsub_multiplier_pipeline_register3  = "UNREGISTERED";
	parameter addnsub_multiplier_pipeline_aclr3      = "NONE";

	
	// Rounding related parameters
	parameter adder1_rounding                   = "NO";
	parameter addnsub1_round_register           = "UNREGISTERED";
	parameter addnsub1_round_aclr               = "NONE";
	parameter addnsub1_round_pipeline_register  = "UNREGISTERED";
	parameter addnsub1_round_pipeline_aclr      = "NONE";
	
	parameter adder3_rounding                   = "NO";
	parameter addnsub3_round_register           = "UNREGISTERED";
	parameter addnsub3_round_aclr               = "NONE";
	parameter addnsub3_round_pipeline_register  = "UNREGISTERED";
	parameter addnsub3_round_pipeline_aclr		  = "NONE";
	
	parameter multiplier01_rounding  = "NO";
	parameter mult01_round_register  = "UNREGISTERED";
	parameter mult01_round_aclr      = "NONE";
	
	parameter multiplier23_rounding  = "NO";
	parameter mult23_round_register  = "UNREGISTERED";
	parameter mult23_round_aclr      = "NONE";
	
	parameter width_msb                       = 17;
	
	parameter output_rounding                 = "NO";
	parameter output_round_type               = "NEAREST_INTEGER";
	parameter output_round_register           = "UNREGISTERED";
	parameter output_round_aclr               = "NONE";
	parameter output_round_pipeline_register  = "UNREGISTERED";
	parameter output_round_pipeline_aclr      = "NONE";
	
	parameter chainout_rounding                 = "NO";
	parameter chainout_round_register           = "UNREGISTERED";
	parameter chainout_round_aclr               = "NONE";
	parameter chainout_round_pipeline_register  = "UNREGISTERED";
	parameter chainout_round_pipeline_aclr      = "NONE";
	parameter chainout_round_output_register    = "UNREGISTERED";
	parameter chainout_round_output_aclr        = "NONE";
	
	
	// Saturation related parameters
	parameter multiplier01_saturation     = "NO";
	parameter mult01_saturation_register  = "UNREGISTERED";
	parameter mult01_saturation_aclr      = "NONE";
	
	parameter multiplier23_saturation     = "NO";
	parameter mult23_saturation_register  = "UNREGISTERED";
	parameter mult23_saturation_aclr      = "NONE";
	
	parameter port_mult0_is_saturated  = "NONE";
	parameter port_mult1_is_saturated  = "NONE";
	parameter port_mult2_is_saturated  = "NONE";
	parameter port_mult3_is_saturated  = "NONE";
	
	parameter width_saturate_sign = 1;
	
	parameter output_saturation                  = "NO";
	parameter port_output_is_overflow            = "PORT_UNUSED";
	parameter output_saturate_type               = "ASYMMETRIC";
	parameter output_saturate_register           = "UNREGISTERED";
	parameter output_saturate_aclr               = "NONE";
	parameter output_saturate_pipeline_register  = "UNREGISTERED";
	parameter output_saturate_pipeline_aclr      = "NONE";
	
	parameter chainout_saturation                  = "NO";
	parameter port_chainout_sat_is_overflow        = "PORT_UNUSED";
	parameter chainout_saturate_register           = "UNREGISTERED";
	parameter chainout_saturate_aclr               = "NONE";
	parameter chainout_saturate_pipeline_register  = "UNREGISTERED";
	parameter chainout_saturate_pipeline_aclr      = "NONE";
	parameter chainout_saturate_output_register    = "UNREGISTERED";
	parameter chainout_saturate_output_aclr        = "NONE";
	
	
	// Scanchain related parameters
	parameter scanouta_register  = "UNREGISTERED";
	parameter scanouta_aclr      = "NONE";
	
	
	// Chain (chainin and chainout) related parameters
	parameter width_chainin  = 1;
	
	parameter chainout_adder     = "NO";
	parameter chainout_register  = "UNREGISTERED";
	parameter chainout_aclr      = "NONE";
	
	parameter zero_chainout_output_register  = "UNREGISTERED";
	parameter zero_chainout_output_aclr      = "NONE";
	
	
	// Rotate & shift related parameters
	parameter shift_mode  = "NO";
	
	parameter rotate_register           = "UNREGISTERED";
	parameter rotate_aclr               = "NONE";
	parameter rotate_pipeline_register  = "UNREGISTERED";
	parameter rotate_pipeline_aclr      = "NONE";
	parameter rotate_output_register    = "UNREGISTERED";
	parameter rotate_output_aclr        = "NONE";
	
	parameter shift_right_register           = "UNREGISTERED";
	parameter shift_right_aclr               = "NONE";
	parameter shift_right_pipeline_register  = "UNREGISTERED";
	parameter shift_right_pipeline_aclr      = "NONE";
	parameter shift_right_output_register    = "UNREGISTERED";
	parameter shift_right_output_aclr        = "NONE";
	
	
	// Loopback related parameters
	parameter zero_loopback_register           = "UNREGISTERED";
	parameter zero_loopback_aclr               = "NONE";
	parameter zero_loopback_pipeline_register  = "UNREGISTERED";
	parameter zero_loopback_pipeline_aclr      = "NONE";
	parameter zero_loopback_output_register    = "UNREGISTERED";
	parameter zero_loopback_output_aclr        = "NONE";
	
	
	// Accumulator and loadconst related parameters
	parameter accumulator      = "NO";
	parameter accum_direction  = "ADD";
	parameter loadconst_value = 0;
	parameter use_sload_accum_port 	= "NO";
	
	parameter accum_sload_register           = "UNREGISTERED";
	parameter accum_sload_aclr               = "NONE";
	parameter accum_sload_pipeline_register  = "UNREGISTERED";
	parameter accum_sload_pipeline_aclr      = "NONE";
	
	parameter loadconst_control_register = "UNREGISTERED";
	parameter loadconst_control_aclr	 = "NONE";
	
	parameter double_accum      = "NO";
	
	// Systolic related parameters
	parameter systolic_delay1 = "UNREGISTERED";
	parameter systolic_delay3 = "UNREGISTERED";
	parameter systolic_aclr1 = "NONE";
	parameter systolic_aclr3= "NONE";
	
	// Preadder related parameters
	parameter preadder_mode  = "SIMPLE";
	
	parameter preadder_direction_0  = "ADD";
	parameter preadder_direction_1  = "ADD";
	parameter preadder_direction_2  = "ADD";
	parameter preadder_direction_3  = "ADD";
	
	parameter width_coef  = 1;
	
	parameter coefsel0_register  = "UNREGISTERED";
	parameter coefsel0_aclr	     = "NONE";
	parameter coefsel1_register  = "UNREGISTERED";
	parameter coefsel1_aclr	     = "NONE";
	parameter coefsel2_register  = "UNREGISTERED";
	parameter coefsel2_aclr	     = "NONE";
	parameter coefsel3_register  = "UNREGISTERED";
	parameter coefsel3_aclr	     = "NONE";

	parameter coef0_0  = 0;
	parameter coef0_1  = 0;
	parameter coef0_2  = 0;
	parameter coef0_3  = 0;
	parameter coef0_4  = 0;
	parameter coef0_5  = 0;
	parameter coef0_6  = 0;
	parameter coef0_7  = 0;

	parameter coef1_0  = 0;
	parameter coef1_1  = 0;
	parameter coef1_2  = 0;
	parameter coef1_3  = 0;
	parameter coef1_4  = 0;
	parameter coef1_5  = 0;
	parameter coef1_6  = 0;
	parameter coef1_7  = 0;

	parameter coef2_0  = 0;
	parameter coef2_1  = 0;
	parameter coef2_2  = 0;
	parameter coef2_3  = 0;
	parameter coef2_4  = 0;
	parameter coef2_5  = 0;
	parameter coef2_6  = 0;
	parameter coef2_7  = 0;

	parameter coef3_0  = 0;
	parameter coef3_1  = 0;
	parameter coef3_2  = 0;
	parameter coef3_3  = 0;
	parameter coef3_4  = 0;
	parameter coef3_5  = 0;
	parameter coef3_6  = 0;
	parameter coef3_7  = 0;	

	//==========================================================
	// Internal parameters declaration
	//==========================================================
	// Width related parameters
		// Register related width parameters
		parameter width_clock_all_wire_msb = 3;   // Clock wire total width
		parameter width_aclr_all_wire_msb = 3;    // Aclr wire total width
		parameter width_ena_all_wire_msb = 3;     // Clock enable wire total width
		
		// Data input width related parameters
		parameter width_a_total_msb  = (width_a * number_of_multipliers) - 1;   // Total width of dataa input
		parameter width_a_msb  = width_a - 1;     // MSB for splited dataa width
		
		parameter width_b_total_msb  = (width_b * number_of_multipliers) - 1;   // Total width of data input
		parameter width_b_msb  = width_b - 1;     // MSB for splited datab width
		
		parameter width_c_total_msb  = (width_c * number_of_multipliers) - 1;   // Total width of datac input
		parameter width_c_msb  = width_c - 1;     // MSB for splited datac width

		// Scanchain width related parameters
		parameter width_scanina = width_a;                  // Width for scanina port
		parameter width_scanina_msb = width_scanina - 1;    // MSB for scanina port
		
		parameter width_scaninb = width_b;                  // Width for scaninb port
		parameter width_scaninb_msb = width_scaninb - 1;    // MSB for scaninb port
		
		parameter width_sourcea_msb = number_of_multipliers -1;    // MSB for sourcea port
		parameter width_sourceb_msb = number_of_multipliers -1;    // MSB for sourceb port
		
		parameter width_scanouta_msb = width_a -1;    // MSB for scanouta port
		parameter width_scanoutb_msb = width_b -1;    // MSB for scanoutb port

		// chain (chainin and chainout) width related parameters
		parameter width_chainin_msb = width_chainin - 1;    // MSB for chainin port
		
		// Result width related parameters
		parameter width_result_msb = width_result - 1;      // MSB for result port
		
		// Coef width related parameters
		parameter width_coef_msb = width_coef -1;           // MSB for selected coef output
	
	
	// Internal width related parameters
		// Input data width related parameters
		parameter dataa_split_ext_require = (port_signa === "PORT_USED") ? 1 : 0;        // Determine dynamic sign extension 
		parameter dataa_port_sign = port_signa;                                          // Dynamic sign port for dataa
		parameter width_a_ext = (dataa_split_ext_require == 1) ? width_a + 1 : width_a ; // Sign extension when require
		parameter width_a_ext_msb = width_a_ext - 1;                                     // MSB for dataa
		
		parameter datab_split_ext_require = (preadder_mode === "SIMPLE") ? ((port_signb === "PORT_USED") ? 1 : 0):
		                                                                   ((port_signa === "PORT_USED") ? 1 : 0) ;   // Determine dynamic sign extension 
		parameter datab_port_sign = (preadder_mode === "SIMPLE") ? port_signb : port_signa;    // Dynamic sign port for dataa
		parameter width_b_ext = (datab_split_ext_require == 1) ? width_b + 1 : width_b;        // Sign extension when require
		parameter width_b_ext_msb = width_b_ext - 1;                                           // MSB for datab
		
		parameter coef_ext_require = (port_signb === "PORT_USED") ? 1 : 0;                // Determine dynamic sign extension 
		parameter coef_port_sign  = port_signb;                                           // Dynamic sign port for coef
		parameter width_coef_ext = (coef_ext_require == 1) ? width_coef + 1 : width_coef; // Sign extension when require
		parameter width_coef_ext_msb = width_coef_ext - 1;                                // MSB for coef
		
		parameter datac_split_ext_require = (port_signb === "PORT_USED") ? 1 : 0;        // Determine dynamic sign extension 
		parameter datac_port_sign = port_signb;                                          // Dynamic sign port for datac
		parameter width_c_ext = (datac_split_ext_require == 1) ? width_c + 1 : width_c;  // Sign extension when require
		parameter width_c_ext_msb = width_c_ext - 1;                                     // MSB for datac
		
		
		// Scanchain width related parameters
		parameter width_scanchain = (port_signa === "PORT_USED") ? width_scanina + 1 : width_scanina;  // Sign extension when require
		parameter width_scanchain_msb = width_scanchain - 1;
		parameter scanchain_port_sign = port_signa;                                      // Dynamic sign port for scanchain
		
		
		// Preadder width related parameters
		parameter preadder_representation = (port_signa === "PORT_USED") ? "SIGNED" : representation_a;   // Representation for preadder adder
		
		parameter width_preadder_input_a = (input_source_a0 === "SCANA")? width_scanchain : width_a_ext;   // Preadder input a selection width
		parameter width_preadder_input_a_msb = width_preadder_input_a - 1;                                      // MSB for preadder input a
		
		parameter width_preadder_adder_result = (width_preadder_input_a > width_b_ext)? width_preadder_input_a + 1 : width_b_ext + 1; // Adder extension by one for the largest width
		
		parameter width_preadder_output_a = (preadder_mode === "INPUT" || preadder_mode === "SQUARE" || preadder_mode === "COEF")? width_preadder_adder_result:
		                                     width_preadder_input_a;              // Preadder first output width
		parameter width_preadder_output_a_msb = width_preadder_output_a - 1;      // MSB for preadder first output width
		
		parameter width_preadder_output_b = (preadder_mode === "INPUT")? width_c_ext :
		                                    (preadder_mode === "SQUARE")? width_preadder_adder_result :
		                                    (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? width_coef_ext :
														width_b_ext;                         // Preadder second output width
		parameter width_preadder_output_b_msb = width_preadder_output_b - 1;     // MSB for preadder second output width
		
		
		// Multiplier width related parameters
		parameter multiplier_input_representation_a = (port_signa === "PORT_USED") ? "SIGNED" : representation_a;   // Representation for multiplier first input
		parameter multiplier_input_representation_b = (preadder_mode === "SQUARE") ? multiplier_input_representation_a :
		                                              (port_signb === "PORT_USED") ? "SIGNED" : representation_b;   // Representation for multiplier second input
		
		parameter width_mult_source_a = width_preadder_output_a;        // Multiplier first input width
		parameter width_mult_source_a_msb = width_mult_source_a - 1;    // MSB for multiplier first input width
		
		parameter width_mult_source_b = width_preadder_output_b;        // Multiplier second input width
		parameter width_mult_source_b_msb = width_mult_source_b - 1;    // MSB for multiplier second input width
		
		parameter width_mult_result = width_mult_source_a + width_mult_source_b +
		                              ((multiplier_input_representation_a === "UNSIGNED") ? 1 : 0) +
		                              ((multiplier_input_representation_b === "UNSIGNED") ? 1 : 0);   // Multiplier result width
		parameter width_mult_result_msb = width_mult_result -1;                                       // MSB for multiplier result width
		
		
		// Adder width related parameters
		parameter width_adder_source = width_mult_result;             // Final adder or systolic adder source width
		parameter width_adder_source_msb = width_adder_source - 1;    // MSB for adder source width
		
		parameter width_adder_result = width_adder_source + ((number_of_multipliers <= 2)? 1 : 2);  // Adder extension (2 when excute two level adder, else 1) and sign extension
		parameter width_adder_result_msb = width_adder_result - 1;                                  // MSB for adder result
		
		
		// Chainout adder width related parameters
		parameter width_chainin_ext = width_result - width_chainin;
		
		// Original output width related parameters
		parameter width_original_result = width_adder_result;               // The original result width without truncated
		parameter width_original_result_msb = width_original_result - 1;    // The MSB for original result 
		
		// Output width related parameters
		parameter result_ext_width    = (width_result_msb > width_original_result_msb) ? width_result_msb - width_original_result_msb : 1;   // Width that require to extend
		
		parameter width_result_output = (width_result_msb > width_original_result_msb) ? width_result : width_original_result + 1;   // Output width that ready for truncated
		parameter width_result_output_msb = width_result_output - 1;    // MSB for output width that ready for truncated
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input related ports
	input [width_a_total_msb : 0] dataa;
	input [width_b_total_msb : 0] datab;
	input [width_c_total_msb : 0] datac;
	
	// Scanchain related ports
	input [width_scanina_msb : 0] scanina;
	input [width_scaninb_msb : 0] scaninb;
	input [width_sourcea_msb : 0] sourcea;
	input [width_sourceb_msb : 0] sourceb;
	
	output [width_scanouta_msb : 0] scanouta;
	output [width_scanoutb_msb : 0] scanoutb;
	
	// Clock related ports
	input clock0, clock1, clock2, clock3;
	
	// Clear related ports
	input aclr0, aclr1, aclr2, aclr3;
	
	// Clock enable related ports
	input ena0, ena1, ena2, ena3;
	
	// Signals control related ports
	input signa, signb;
	input addnsub1, addnsub3;
	
	// Rounding related ports
	input mult01_round, mult23_round;
	input addnsub1_round, addnsub3_round;
	input output_round;
	input chainout_round;
	
	// Saturation related ports
	input mult01_saturation, mult23_saturation;
	input output_saturate;
	input chainout_saturate;
	
	output mult0_is_saturated, mult1_is_saturated, mult2_is_saturated, mult3_is_saturated;
	output chainout_sat_overflow;
	
	// chain (chainin and chainout) related port
	input [width_chainin_msb : 0] chainin;
	input zero_chainout;
	
	// Rotate & shift related port
	input rotate;
	input shift_right;
	
	// Loopback related port
	input zero_loopback;
	
	// Accumulator related port
	input accum_sload;
	input sload_accum;
	
	// Preadder related port
	input [2 : 0] coefsel0, coefsel1, coefsel2, coefsel3;
	
	// Output related port
	output [width_result_msb : 0] result;
	output overflow;
	
	//==========================================================
	// Declar default driver for unused output port
	//==========================================================
	// Scanchain. Saturation and Output related ports
	
	// synthesis read_comments_as_HDL on
	//tri0 [width_scanouta_msb : 0] scanouta;
	//tri0 [width_scanoutb_msb : 0] scanoutb;
	//
	//tri0 mult0_is_saturated, mult1_is_saturated, mult2_is_saturated, mult3_is_saturated;
	//tri0 chainout_sat_overflow;
	//
	//tri0 overflow;
	// synthesis read_comments_as_HDL off
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Register related wires and registers
	wire [width_clock_all_wire_msb : 0] clock_all_wire = {clock3, clock2, clock1, clock0};
	wire [width_aclr_all_wire_msb : 0] aclr_all_wire = {aclr3, aclr2, aclr1, aclr0};
	wire [width_ena_all_wire_msb : 0] ena_all_wire = {ena3, ena2, ena1, ena0};
	
	// Input A related wires and registers
	wire [width_a_total_msb : 0] dataa_split_input = dataa;
	wire [width_a_ext_msb : 0] dataa_0_input, dataa_1_input, dataa_2_input, dataa_3_input;  // Wire contain data a after split, reg and ext
	
	// Input B related wires and registers
	wire [width_b_total_msb : 0] datab_split_input = datab;
	wire [width_b_ext_msb : 0] datab_0_input, datab_1_input, datab_2_input, datab_3_input;  // Wire contain data b after split, reg and ext
	
	// Input C related wires and registers
	wire [width_c_total_msb : 0] datac_split_input = datac;
	wire [width_c_ext_msb : 0] datac_0_input, datac_1_input, datac_2_input, datac_3_input;  // Wire contain data b after split, reg and ext
	
	// Input coef related wires and registers
	wire [width_coef_ext_msb : 0] coefsel0_input, coefsel1_input, coefsel2_input, coefsel3_input;  // Wire contain data b after split, reg and ext
	
	// Scanchain related wires and registers
	wire [width_scanchain_msb : 0] scanchain_output_0, scanchain_output_1, scanchain_output_2, scanchain_output_3;
	wire [width_scanchain_msb : 0] scanout_wire;
	
	// Signed related wire and registers
	wire signa_wire, signb_wire;  // Wire contain sign signal, before being used
	
	wire dataa_sign_wire = signa_wire;
	wire datab_sign_wire = (preadder_mode === "SIMPLE") ? signb_wire : signa_wire; // Sign representation for data a and b
	wire datac_sign_wire = signb_wire;
	wire scanchain_sign_wire = signa_wire;
	
	// Preadder related wires and registers
	wire [width_preadder_input_a_msb : 0] preadder_dataa_0_input, preadder_dataa_1_input, preadder_dataa_2_input, preadder_dataa_3_input;
	wire [width_preadder_output_a_msb : 0] preadder_output_a0, preadder_output_a1, preadder_output_a2, preadder_output_a3;
	wire [width_preadder_output_b_msb : 0] preadder_output_b0, preadder_output_b1, preadder_output_b2, preadder_output_b3;
	
	// Multiplier related wires and registers
	wire [width_mult_source_a_msb : 0] mult_input_source_a0, mult_input_source_a1, mult_input_source_a2, mult_input_source_a3;
	wire [width_mult_source_b_msb : 0] mult_input_source_b0, mult_input_source_b1, mult_input_source_b2, mult_input_source_b3;
	wire [width_mult_result_msb : 0] mult_output_0, mult_output_1, mult_output_2, mult_output_3;
	
	// Adder related wires and registers
	wire [width_adder_source_msb : 0] adder_source_0, adder_source_1, adder_source_2, adder_source_3;
	wire [width_adder_result_msb : 0] adder_output;
	
	// Systolic related wires and registers
	wire [width_result_msb : 0] systolic_adder_output;
	
	// Result related wires and registers
	wire [width_result_output_msb : 0] result_wire;
	wire [width_result_msb : 0] result_wire_ext;
	
	wire [width_result_msb : 0] result_reg_input;
	wire [width_result_msb : 0] result_reg_output;
	
	wire [width_result_msb : 0] output_wire;
	
	// Accumulator related wires and registers
	wire [width_result_msb : 0] accum_cal_source;
	wire [width_result_msb : 0] accum_prev_source;
	
	wire [width_result_msb : 0] accum_output;
	
	// Chainout adder related wires and registers
	wire [width_result_msb : 0] chainout_adder_output;
	
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Scanchain assignment
	assign scanouta = scanout_wire[width_scanouta_msb : 0];
	
	// Preadder assignment
	assign preadder_dataa_0_input = (input_source_a0 === "SCANA")? scanchain_output_0 : dataa_0_input;
	assign preadder_dataa_1_input = (input_source_a1 === "SCANA")? scanchain_output_1 : dataa_1_input;
	assign preadder_dataa_2_input = (input_source_a2 === "SCANA")? scanchain_output_2 : dataa_2_input;
	assign preadder_dataa_3_input = (input_source_a3 === "SCANA")? scanchain_output_3 : dataa_3_input;
	
	// Multiplier assignment
	assign mult_input_source_a0 = preadder_output_a0;
	assign mult_input_source_a1 = preadder_output_a1;
	assign mult_input_source_a2 = preadder_output_a2;
	assign mult_input_source_a3 = preadder_output_a3;
	
	assign mult_input_source_b0 = preadder_output_b0;
	assign mult_input_source_b1 = preadder_output_b1;
	assign mult_input_source_b2 = preadder_output_b2;
	assign mult_input_source_b3 = preadder_output_b3;
	
	// Final adder and systolic assignmnet
	assign adder_source_0 = mult_output_0;
	assign adder_source_1 = mult_output_1;
	assign adder_source_2 = mult_output_2;
	assign adder_source_3 = mult_output_3;
	
	// adder (result) related assignment
	assign result_wire = {{result_ext_width{adder_output[width_adder_result_msb]}},adder_output};
	assign result_wire_ext = (systolic_delay1 === "UNREGISTERED") ? result_wire[width_result_msb : 0] : systolic_adder_output;
	
	// Accumulator assignmnet
	assign accum_cal_source = result_wire_ext;
	assign accum_prev_source = output_wire;
	
	// Register (clock and aclr) assignment
	assign result_reg_input = chainout_adder_output;
	assign output_wire = result_reg_output;  
	
	// Final output assignment
	assign result = output_wire;  

	
	//==========================================================
	// Sign handling part
	//==========================================================
	// Sign signal registered
	ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(signed_register_a), .register_aclr(signed_aclr_a))
	signa_reg_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in(signa), .data_out(signa_wire));
	
	ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(signed_register_b), .register_aclr(signed_aclr_b))
	signb_reg_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in(signb), .data_out(signb_wire) );
	
	
	//==========================================================
	// Input data handling part
	//==========================================================
	// Dataa split and register function
	ama_data_split_reg_ext_function #(.width_data_in(width_a), .width_data_out(width_a_ext), .register_clock_0(input_register_a0), .register_aclr_0(input_aclr_a0), .register_clock_1(input_register_a1), .register_aclr_1(input_aclr_a1), .register_clock_2(input_register_a2), .register_aclr_2(input_aclr_a2), .register_clock_3(input_register_a3), .register_aclr_3(input_aclr_a3), .number_of_multipliers(number_of_multipliers), .port_sign(dataa_port_sign))
	dataa_split(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(dataa_sign_wire), .data_in(dataa_split_input), .data_out_0(dataa_0_input), .data_out_1(dataa_1_input), .data_out_2(dataa_2_input), .data_out_3(dataa_3_input));
	
	// Datab split and register function
	ama_data_split_reg_ext_function #(.width_data_in(width_b), .width_data_out(width_b_ext), .register_clock_0(input_register_b0), .register_aclr_0(input_aclr_b0), .register_clock_1(input_register_b1), .register_aclr_1(input_aclr_b1), .register_clock_2(input_register_b2), .register_aclr_2(input_aclr_b2), .register_clock_3(input_register_b3), .register_aclr_3(input_aclr_b3), .number_of_multipliers(number_of_multipliers), .port_sign(datab_port_sign))
	datab_split(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(datab_sign_wire), .data_in(datab_split_input), .data_out_0(datab_0_input), .data_out_1(datab_1_input), .data_out_2(datab_2_input), .data_out_3(datab_3_input));
	
	// Datac split and register function
	ama_data_split_reg_ext_function #(.width_data_in(width_c), .width_data_out(width_c_ext), .register_clock_0(input_register_c0), .register_aclr_0(input_aclr_c0), .register_clock_1(input_register_c1), .register_aclr_1(input_aclr_c1), .register_clock_2(input_register_c2), .register_aclr_2(input_aclr_c2), .register_clock_3(input_register_c3), .register_aclr_3(input_aclr_c3), .number_of_multipliers(number_of_multipliers), .port_sign(datac_port_sign))
	datac_split(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(datac_sign_wire), .data_in(datac_split_input), .data_out_0(datac_0_input), .data_out_1(datac_1_input), .data_out_2(datac_2_input), .data_out_3(datac_3_input));
	
	// Coef selection and register function
	generate
		if (preadder_mode === "CONSTANT" || preadder_mode === "COEF")
		begin
			wire coef_sign_wire = signb_wire;
			
			ama_coef_reg_ext_function #(.width_coef(width_coef), .width_data_out(width_coef_ext), .register_clock_0(coefsel0_register), .register_aclr_0(coefsel0_aclr), .register_clock_1(coefsel1_register), .register_aclr_1(coefsel1_aclr), .register_clock_2(coefsel2_register), .register_aclr_2(coefsel2_aclr), .register_clock_3(coefsel3_register), .register_aclr_3(coefsel3_aclr), .number_of_multipliers(number_of_multipliers), .port_sign(coef_port_sign),
			.coef0_0(coef0_0), .coef0_1(coef0_1), .coef0_2(coef0_2), .coef0_3(coef0_3), .coef0_4(coef0_4), .coef0_5(coef0_5), .coef0_6(coef0_6), .coef0_7(coef0_7),
			.coef1_0(coef1_0), .coef1_1(coef1_1), .coef1_2(coef1_2), .coef1_3(coef1_3), .coef1_4(coef1_4), .coef1_5(coef1_5), .coef1_6(coef1_6), .coef1_7(coef1_7),
			.coef2_0(coef2_0), .coef2_1(coef2_1), .coef2_2(coef2_2), .coef2_3(coef2_3), .coef2_4(coef2_4), .coef2_5(coef2_5), .coef2_6(coef2_6), .coef2_7(coef2_7),
			.coef3_0(coef3_0), .coef3_1(coef3_1), .coef3_2(coef3_2), .coef3_3(coef3_3), .coef3_4(coef3_4), .coef3_5(coef3_5), .coef3_6(coef3_6), .coef3_7(coef3_7))
			coefsel_reg_ext_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(coef_sign_wire), .coefsel0(coefsel0), .coefsel1(coefsel1), .coefsel2(coefsel2), .coefsel3(coefsel3), .data_out_0(coefsel0_input), .data_out_1(coefsel1_input), .data_out_2(coefsel2_input), .data_out_3(coefsel3_input));
		end
	endgenerate
	
	
	// Scanchain selection and register function
	ama_scanchain #(.width_scanin(width_scanina), .width_scanchain(width_scanchain), .input_register_clock_0(input_register_a0), .input_register_aclr_0(input_aclr_a0), .input_register_clock_1(input_register_a1), .input_register_aclr_1(input_aclr_a1), .input_register_clock_2(input_register_a2), .input_register_aclr_2(input_aclr_a2), .input_register_clock_3(input_register_a3), .input_register_aclr_3(input_aclr_a3), .scanchain_register_clock(scanouta_register), .scanchain_register_aclr(scanouta_aclr), .port_sign(scanchain_port_sign), .number_of_multipliers(number_of_multipliers))
	scanchain_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(scanchain_sign_wire), .scanin(scanina), .data_out_0(scanchain_output_0), .data_out_1(scanchain_output_1), .data_out_2(scanchain_output_2), .data_out_3(scanchain_output_3), .scanout(scanout_wire));
	
	
	//==========================================================
	// Preadder part (input selection)
	//==========================================================
	ama_preadder_function #(.preadder_mode(preadder_mode), .width_in_a(width_preadder_input_a), .width_in_b(width_b_ext), .width_in_c(width_c_ext), .width_in_coef(width_coef_ext), .width_result_a(width_preadder_output_a), .width_result_b(width_preadder_output_b), .preadder_direction_0(preadder_direction_0), .preadder_direction_1(preadder_direction_1), .preadder_direction_2(preadder_direction_2), .preadder_direction_3(preadder_direction_3), .representation_preadder_adder(preadder_representation))
	preadder_block(.dataa_in_0(preadder_dataa_0_input), .dataa_in_1(preadder_dataa_1_input), .dataa_in_2(preadder_dataa_2_input), .dataa_in_3(preadder_dataa_3_input), .datab_in_0(datab_0_input), .datab_in_1(datab_1_input), .datab_in_2(datab_2_input), .datab_in_3(datab_3_input), .datac_in_0(datac_0_input), .datac_in_1(datac_1_input), .datac_in_2(datac_2_input), .datac_in_3(datac_3_input), .coef0(coefsel0_input), .coef1(coefsel1_input), .coef2(coefsel2_input), .coef3(coefsel3_input), .result_a0(preadder_output_a0), .result_a1(preadder_output_a1), .result_a2(preadder_output_a2), .result_a3(preadder_output_a3), .result_b0(preadder_output_b0), .result_b1(preadder_output_b1), .result_b2(preadder_output_b2), .result_b3(preadder_output_b3));
	
	
	//==========================================================
	// Multiplier part
	//==========================================================
	// Multiplier function
	ama_multiplier_function #(.width_data_in_a(width_mult_source_a), .width_data_in_b(width_mult_source_b), .multiplier_input_representation_a(multiplier_input_representation_a), .multiplier_input_representation_b(multiplier_input_representation_b), .width_data_out(width_mult_result), .number_of_multipliers(number_of_multipliers), .multiplier_register0(multiplier_register0), .multiplier_aclr0(multiplier_aclr0), .multiplier_register1(multiplier_register1), .multiplier_aclr1(multiplier_aclr1), .multiplier_register2(multiplier_register2), .multiplier_aclr2(multiplier_aclr2), .multiplier_register3(multiplier_register3), .multiplier_aclr3(multiplier_aclr3))
	multiplier_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in_a0(mult_input_source_a0), .data_in_a1(mult_input_source_a1), .data_in_a2(mult_input_source_a2), .data_in_a3(mult_input_source_a3), .data_in_b0(mult_input_source_b0), .data_in_b1(mult_input_source_b1), .data_in_b2(mult_input_source_b2), .data_in_b3(mult_input_source_b3), .data_out_0(mult_output_0), .data_out_1(mult_output_1), .data_out_2(mult_output_2), .data_out_3(mult_output_3));
	
	
	//==========================================================
	// Final adder part
	//==========================================================
	// Final adder function
	ama_adder_function #(.width_data_in(width_adder_source), .width_data_out(width_adder_result), .number_of_adder_input(number_of_multipliers), .adder1_direction(multiplier1_direction), .adder3_direction(multiplier3_direction), .representation("SIGNED"), .port_addnsub1(port_addnsub1), .addnsub_multiplier_register1(addnsub_multiplier_register1), .addnsub_multiplier_aclr1(addnsub_multiplier_aclr1), .port_addnsub3(port_addnsub3), .addnsub_multiplier_register3(addnsub_multiplier_register3), .addnsub_multiplier_aclr3(addnsub_multiplier_aclr3))
	final_adder_block (.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in_0(adder_source_0), .data_in_1(adder_source_1), .data_in_2(adder_source_2), .data_in_3(adder_source_3), .data_out(adder_output), .addnsub1(addnsub1), .addnsub3(addnsub3));
	
	
	//==========================================================
	// Systolic part
	//==========================================================
	// Systolic function
	generate
		if (systolic_delay1 != "UNREGISTERED")
		begin
			ama_systolic_adder_function #(.width_data_in(width_adder_source), .width_chainin(width_chainin), .width_data_out(width_result), .number_of_adder_input(number_of_multipliers), .systolic_delay1(systolic_delay1), .systolic_aclr1(systolic_aclr1), .systolic_delay3(systolic_delay3), .systolic_aclr3(systolic_aclr3), .adder1_direction(multiplier1_direction), .adder3_direction(multiplier3_direction), .port_addnsub1(port_addnsub1), .addnsub_multiplier_register1(addnsub_multiplier_register1), .addnsub_multiplier_aclr1(addnsub_multiplier_aclr1), .port_addnsub3(port_addnsub3), .addnsub_multiplier_register3(addnsub_multiplier_register3), .addnsub_multiplier_aclr3(addnsub_multiplier_aclr3))
			systolic_adder_block(.data_in_0(adder_source_0), .data_in_1(adder_source_1), .data_in_2(adder_source_2), .data_in_3(adder_source_3), .chainin(chainin), .clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_out(systolic_adder_output), .addnsub1(addnsub1), .addnsub3(addnsub3));
		end
	endgenerate
	
	
	//==========================================================
	// Accumulator part
	//==========================================================
	// Accumulator function
	ama_accumulator_function #(.width_result(width_result), .accumulator(accumulator), .accum_direction(accum_direction), .loadconst_value(loadconst_value), .accum_sload_register(accum_sload_register), .accum_sload_aclr(accum_sload_aclr), .double_accum(double_accum), .output_register(output_register), .output_aclr(output_aclr), .use_sload_accum_port(use_sload_accum_port))
	accumulator_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .accum_sload(accum_sload), .sload_accum(sload_accum), .data_result(accum_cal_source), .prev_result(accum_prev_source), .result(accum_output));
	
	parameter width_chainout_adder_output = (chainout_adder === "YES")? width_result : width_chainin;
	//==========================================================
	// Chainout adder part
	//==========================================================
	// Chainout adder function
	generate
		if (chainout_adder === "YES")
		begin
			// Width extend for encryption model, due to encryption model will still compile the hierarchy and cause width mistmatch for the chainin input
			//   This happen when chainin width is not equal to result width
			wire [width_result_msb : 0] chainin_wire = (width_chainin_ext > 0) ? {{width_chainin_ext{1'b0}},chainin} : chainin;
			
			ama_adder_function #(.width_data_in(width_result), .width_data_out(width_result), .number_of_adder_input(2), .adder1_direction("ADD"), .adder3_direction("ADD"), .representation("SIGNED"))
			chainout_adder_block (.data_in_0(chainin_wire), .data_in_1(accum_output), .data_in_2(), .data_in_3(), .data_out(chainout_adder_output), .clock(), .aclr(), .ena(), .addnsub1(), .addnsub3());
		end
		else
		begin
			assign chainout_adder_output = accum_output;
		end
	endgenerate
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	ama_register_function #(.width_data_in(width_result), .width_data_out(width_result), .register_clock(output_register), .register_aclr(output_aclr))
	output_reg_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in(result_reg_input), .data_out(result_reg_output));
	
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_signed_extension_function
// Use in          : altera_mult_add_rtl
//
// Description     : Registered function with dynamic sign extension
//--------------------------------------------------------------------------
module ama_signed_extension_function (
	data_in,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter representation = "UNSIGNED";          // Representation for the sign extension
	parameter width_data_in = 1;                    // Input data bus width
	parameter width_data_out = width_data_in + 1;   // Output data bus width
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;    // MSB for input data
	parameter width_data_out_msb = width_data_out -1;   // MSB for output data
	
	parameter width_data_ext = width_data_in + 1;       // Extend data width
	parameter wdith_data_ext_msb = width_data_ext - 1;  // MSB for extend data width
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input port define
	input [width_data_in_msb : 0] data_in;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Bit extension selection wire
	wire data_in_bit_ext = (representation === "UNSIGNED")? 1'b0 :
                          (representation === "SIGNED")? data_in[width_data_in_msb] : 
                           1'bz;  // Decide bit for the extansion
	
	// Extended data wire
	wire [wdith_data_ext_msb : 0] data_ext = {data_in_bit_ext, data_in};
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Output assignment
	assign data_out = data_ext[width_data_out_msb : 0];
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_dynamic_signed_function
// Use in          : altera_mult_add_rtl
//
// Description     : Determine dynamic sign extension function
//--------------------------------------------------------------------------
module ama_dynamic_signed_function (
	data_in,
	sign,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter port_sign = "PORT_CONNECTIVITY";       // Dynamic sign extension port condition
	parameter width_data_in = 1;                     // Data input bus width
	parameter width_data_out = width_data_in + 1;    // Data output bus width
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;     // MSB for input data
	parameter width_data_out_msb = width_data_out -1;    // MSB for output data
	
	parameter width_data_out_wire = width_data_in + 1;              // Output wire width with 1 bit extra
	parameter width_data_out_wire_msb = width_data_out_wire - 1;    // MSB for output wire width
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Input port define
	input [width_data_in_msb : 0] data_in;
	
	// Dynamic sign port define
	input sign;
	
	// Output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Bit extension selection
	wire data_in_bit_ext = (port_sign === "PORT_USED")? ((sign == 1'b0)? 1'b0 : data_in[width_data_in_msb]) :
									1'bz;  // Decide bit for the extansion
	
	// Bit extension wire
	wire [width_data_out_wire_msb : 0] data_out_wire = {data_in_bit_ext, data_in};
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Output assignment
	assign data_out = data_out_wire[width_data_out_msb : 0];
	
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_register_function
// Use in          : altera_mult_add_rtl
//
// Description     : Asynchronous clear register function
//--------------------------------------------------------------------------
module ama_register_function (
	clock,
	aclr,
	ena,
	data_in,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;                 // Input data bus width
	parameter width_data_out = 1;                // Output data bus width
	parameter register_clock = "UNREGISTERED";   // Clock for register
	parameter register_aclr = "NONE";          // Aclr for register
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;   // MSB for input data
	
	parameter width_data_out_msb = width_data_out -1;  // MSB for output data

	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Input port define
	input [width_data_in_msb : 0] data_in;
	
	// Output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Clock that used for registered
	wire clock_used_wire;
	
	// Asynchronous clear that used for registered
	wire aclr_used_wire;
	
	// Clock enable that used for registered
	wire ena_used_wire;
	
	// Input wire
	wire [width_data_in_msb : 0] data_in_wire = data_in;
	
	// Data output after registered
	reg [width_data_out_msb : 0] data_out_wire;
	
	//==========================================================
	// Assignment
	//==========================================================
	assign clock_used_wire  = (register_clock === "CLOCK3")? clock[3] :
                             (register_clock === "CLOCK2")? clock[2] :
                             (register_clock === "CLOCK1")? clock[1] : 
                             (register_clock === "CLOCK0")? clock[0] : "";  // Clock select
	
	assign aclr_used_wire  = (register_aclr === "ACLR3")? aclr[3] : 
                            (register_aclr === "ACLR2")? aclr[2] :
                            (register_aclr === "ACLR1")? aclr[1] : 
                            (register_aclr === "ACLR0")? aclr[0] : ""; // Aclr select
	
	assign ena_used_wire  = (register_clock === "CLOCK3")? ena[3] :
                           (register_clock === "CLOCK2")? ena[2] :
                           (register_clock === "CLOCK1")? ena[1] : 
                           (register_clock === "CLOCK0")? ena[0] : 1'b1;  // Clock enable select
	
	// Output assignment
	assign data_out = (register_clock === "UNREGISTERED")? data_in_wire : data_out_wire;
	
	// Initial output data to prevent tri-state or don't careoutput happen
	initial 
	data_out_wire = {width_data_out{1'b0}};
	
	// Asynchronous clear register section
	always @(posedge clock_used_wire or posedge aclr_used_wire)
	begin
		if (aclr_used_wire == 1'b1 )
			data_out_wire <= {width_data_out{1'b0}};
		else if (ena_used_wire == 1'b1)
			data_out_wire <= data_in_wire;
	end
	
	
	//==========================================================
	// Condition check
	//==========================================================
	initial /* synthesis enable_verilog_initial_construct */
	begin
		if(register_clock != "UNREGISTERED" && register_clock != "CLOCK0" && register_clock != "CLOCK1" && register_clock != "CLOCK2" && register_clock != "CLOCK3")
			$display("Error: Clock source error: illegal value %s", register_clock);
		
		if(register_aclr != "NONE" && register_aclr != "ACLR0" && register_aclr != "ACLR1" && register_aclr != "ACLR2" && register_aclr != "ACLR3" && register_aclr != "UNUSED")
			$display("Error: Asynchronous clear source error: illegal value %s", register_aclr);
	end
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_register_with_ext_function
// Use in          : altera_mult_add_rtl
//
// Description     : Registered function with dynamic sign extension
//--------------------------------------------------------------------------
module ama_register_with_ext_function (
	clock,
	aclr,
	ena,
	sign,
	data_in,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;                      // Data input bus width
	parameter width_data_out = width_data_in + 1;     // Data output bus width
	
	parameter register_clock = "UNREGISTERED";        // Clock for register
	parameter register_aclr = "NONE";               // Aclr for register
	parameter port_sign = "PORT_CONNECTIVITY";        // Dynamic sign extension port condition
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;   // MSB for input data
	
	parameter width_data_out_msb = width_data_out -1;  // MSB for output data
	
	parameter width_sign_ext_output = (port_sign === "PORT_USED")? width_data_in + 1 : width_data_in;   // output with extend or without extend
	parameter width_sign_ext_output_msb = width_sign_ext_output -1;  // MSB for sign extend output
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic sign port define
	input sign;
	
	// Input port define
	input [width_data_in_msb : 0] data_in;
	
	// Output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Data after dynamic signed extension
	//wire [width_sign_ext_output_msb : 0] sign_ext_output;
	
	//Register output
	wire [width_data_in_msb : 0] register_output;
	
	//==========================================================
	// Main function execution
	//==========================================================	
	// Register
	ama_register_function #(.width_data_in(width_data_in), .width_data_out(width_data_in), .register_clock(register_clock), .register_aclr(register_aclr))
	data_register_block (.clock(clock), .aclr(aclr), .ena(ena), .data_in(data_in), .data_out(register_output));
	
	// Sign extension
	ama_dynamic_signed_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .port_sign(port_sign))
	data_signed_extension_block (.data_in(register_output), .sign(sign), .data_out(data_out));
	
	//==========================================================
	// Condition check
	//==========================================================
	initial /* synthesis enable_verilog_initial_construct */
		if( width_sign_ext_output != width_data_out)
		begin
			$display("Error: Function output width and assign output width not same. Happen in ama_register_with_ext_function function for altera_mult_add_rtl");
		end
	
endmodule



//--------------------------------------------------------------------------
// Module Name     : ama_data_split_reg_ext_function
// Use in          : altera_mult_add_rtl
//
// Description     : Split data evenly according to the number of multiplier
//--------------------------------------------------------------------------
module ama_data_split_reg_ext_function (
	clock,
	aclr,
	ena,
	sign,
	data_in,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;                    // Input data bus width
	parameter width_data_out = width_data_in + 1;   // Output data bus width
	
	parameter register_clock_0 = "UNREGISTERED";    // Clock for first data output register
	parameter register_aclr_0 = "NONE";           // Aclr for first data output register
	
	parameter register_clock_1 = "UNREGISTERED";    // Clock for second data output register
	parameter register_aclr_1 = "NONE";           // Aclr for second data output register
	
	parameter register_clock_2 = "UNREGISTERED";    // Clock for third data output register
	parameter register_aclr_2 = "NONE";           // Aclr for third data output register
	
	parameter register_clock_3 = "UNREGISTERED";    // Clock for fourth data output register
	parameter register_aclr_3 = "NONE";           // Aclr for fourth data output register
	
	parameter number_of_multipliers = 1;            // Total number of data going to be splited    
	parameter port_sign = "PORT_CONNECTIVITY";      // Dynamic sign extension port condition
	
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;    // MSB of input data
	
	parameter width_data_in_total_msb  = width_data_in * number_of_multipliers - 1;   // MSB of total input data width
	
	parameter width_data_out_msb = width_data_out -1;    // MSB of output data
	
	// Width of the individual splited data width
	parameter width_data_in_0_msb  = width_data_in - 1;
	parameter width_data_in_0_lsb  = 0;
	parameter width_data_in_1_msb  = (number_of_multipliers >= 2)? (width_data_in * 2 - 1) : 0;
	parameter width_data_in_1_lsb  = (number_of_multipliers >= 2)? (width_data_in) : 0;
	parameter width_data_in_2_msb  = (number_of_multipliers >= 3)? (width_data_in * 3 - 1) : 0;
	parameter width_data_in_2_lsb  = (number_of_multipliers >= 3)? (width_data_in * 2) : 0;
	parameter width_data_in_3_msb  = (number_of_multipliers >= 4)? (width_data_in * 4 - 1) : 0;
	parameter width_data_in_3_lsb  = (number_of_multipliers >= 4)? (width_data_in * 3) : 0;
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic sign port define
	input sign;
	
	// Data input port define
	input [width_data_in_total_msb : 0] data_in;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out_0, data_out_1, data_out_2, data_out_3;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Split data
	wire [width_data_in_msb : 0] data_split_0, data_split_1, data_split_2, data_split_3;
	
	// Split data after registered and dynamic extension
	wire [width_data_out_msb : 0] data_out_wire_0, data_out_wire_1, data_out_wire_2, data_out_wire_3;
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Data split assignment
	assign data_split_0 = data_in[width_data_in_0_msb : width_data_in_0_lsb];
	assign data_split_1 = (number_of_multipliers >= 2)? data_in[width_data_in_1_msb : width_data_in_1_lsb] : {(width_data_in ){1'bx}};
	assign data_split_2 = (number_of_multipliers >= 3)? data_in[width_data_in_2_msb : width_data_in_2_lsb] : {(width_data_in ){1'bx}};
	assign data_split_3 = (number_of_multipliers == 4)? data_in[width_data_in_3_msb : width_data_in_3_lsb] : {(width_data_in ){1'bx}};
	
	// Output assignment
	assign data_out_0 = data_out_wire_0;
	assign data_out_1 = data_out_wire_1;
	assign data_out_2 = data_out_wire_2;
	assign data_out_3 = data_out_wire_3;
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	ama_register_with_ext_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .register_clock(register_clock_0), .register_aclr(register_aclr_0), .port_sign(port_sign))
	data_register_block_0(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(data_split_0), .data_out(data_out_wire_0));
	
	ama_register_with_ext_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .register_clock(register_clock_1), .register_aclr(register_aclr_1), .port_sign(port_sign))
	data_register_block_1(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(data_split_1), .data_out(data_out_wire_1));
	
	ama_register_with_ext_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .register_clock(register_clock_2), .register_aclr(register_aclr_2), .port_sign(port_sign))
	data_register_block_2(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(data_split_2), .data_out(data_out_wire_2));
	
	ama_register_with_ext_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .register_clock(register_clock_3), .register_aclr(register_aclr_3), .port_sign(port_sign))
	data_register_block_3(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(data_split_3), .data_out(data_out_wire_3));
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_coef_reg_ext_function
// Use in          : altera_mult_add_rtl
//
// Description     : Contain coef selection function
//--------------------------------------------------------------------------
module ama_coef_reg_ext_function (
	clock,
	aclr,
	ena,
	sign,
	coefsel0,
	coefsel1,
	coefsel2,
	coefsel3,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_coef = 1;                      // Coef bus width
	parameter width_data_out = width_coef + 1;     // Coef output bus width
	
	parameter register_clock_0 = "UNREGISTERED";   // Clock for first coefsel register
	parameter register_aclr_0 = "NONE";          // aclr for first coefsel register
	
	parameter register_clock_1 = "UNREGISTERED";   // Clock for second coefsel register
	parameter register_aclr_1 = "NONE";          // aclr for second coefsel register
	
	parameter register_clock_2 = "UNREGISTERED";   // Clock for third coefsel register
	parameter register_aclr_2 = "NONE";          // aclr for third coefsel register
	
	parameter register_clock_3 = "UNREGISTERED";   // Clock for fourth coefsel register
	parameter register_aclr_3 = "NONE";          // aclr for fourth coefsel register
	
	parameter number_of_multipliers = 1;           // Number of coef output
	parameter port_sign = "PORT_CONNECTIVITY";     // Dynamic sign extension port condition
	
	// Internal used parameters
	parameter width_coef_msb = (width_coef > 1) ? width_coef - 1 : 0;   // MSB for coef data
	
	parameter width_data_out_msb = width_data_out -1;   // MSB of output data
	
	parameter width_coef_ext = (port_sign === "PORT_USED") ? width_coef + 1 : width_coef;   // Coef width with extend or without extend
	
	// Inherite parameters (ROM value)
	parameter [width_coef_msb : 0] coef0_0  = 0;   // Coef pre-define value
	parameter [width_coef_msb : 0] coef0_1  = 0;
	parameter [width_coef_msb : 0] coef0_2  = 0;
	parameter [width_coef_msb : 0] coef0_3  = 0;
	parameter [width_coef_msb : 0] coef0_4  = 0;
	parameter [width_coef_msb : 0] coef0_5  = 0;
	parameter [width_coef_msb : 0] coef0_6  = 0;
	parameter [width_coef_msb : 0] coef0_7  = 0;

	parameter [width_coef_msb : 0] coef1_0  = 0;
	parameter [width_coef_msb : 0] coef1_1  = 0;
	parameter [width_coef_msb : 0] coef1_2  = 0;
	parameter [width_coef_msb : 0] coef1_3  = 0;
	parameter [width_coef_msb : 0] coef1_4  = 0;
	parameter [width_coef_msb : 0] coef1_5  = 0;
	parameter [width_coef_msb : 0] coef1_6  = 0;
	parameter [width_coef_msb : 0] coef1_7  = 0;

	parameter [width_coef_msb : 0] coef2_0  = 0;
	parameter [width_coef_msb : 0] coef2_1  = 0;
	parameter [width_coef_msb : 0] coef2_2  = 0;
	parameter [width_coef_msb : 0] coef2_3  = 0;
	parameter [width_coef_msb : 0] coef2_4  = 0;
	parameter [width_coef_msb : 0] coef2_5  = 0;
	parameter [width_coef_msb : 0] coef2_6  = 0;
	parameter [width_coef_msb : 0] coef2_7  = 0;

	parameter [width_coef_msb : 0] coef3_0  = 0;
	parameter [width_coef_msb : 0] coef3_1  = 0;
	parameter [width_coef_msb : 0] coef3_2  = 0;
	parameter [width_coef_msb : 0] coef3_3  = 0;
	parameter [width_coef_msb : 0] coef3_4  = 0;
	parameter [width_coef_msb : 0] coef3_5  = 0;
	parameter [width_coef_msb : 0] coef3_6  = 0;
	parameter [width_coef_msb : 0] coef3_7  = 0;
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic sign port define
	input sign;
	
	// coefsel input port define
	input [2 : 0] coefsel0, coefsel1, coefsel2, coefsel3;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out_0, data_out_1, data_out_2, data_out_3;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Memory that store the predefine value
	reg [width_coef_msb : 0] coef0 [7:0], coef1 [7:0], coef2 [7:0], coef3 [7:0];
	
	// Register output for coefsel
	wire [2 : 0] coefsel0_reg_out, coefsel1_reg_out, coefsel2_reg_out, coefsel3_reg_out;
	
	// Selected coef value
	wire [width_coef_msb : 0] coef0_wire, coef1_wire, coef2_wire, coef3_wire;

	
	//==========================================================
	// Coef value initialize
	//==========================================================
	initial
	begin
		coef0[0] = coef0_0;   // Assign constant coef value
		coef0[1] = coef0_1;
		coef0[2] = coef0_2;
		coef0[3] = coef0_3;
		coef0[4] = coef0_4;
		coef0[5] = coef0_5;
		coef0[6] = coef0_6;
		coef0[7] = coef0_7;
		
		coef1[0] = coef1_0;
		coef1[1] = coef1_1;
		coef1[2] = coef1_2;
		coef1[3] = coef1_3;
		coef1[4] = coef1_4;
		coef1[5] = coef1_5;
		coef1[6] = coef1_6;
		coef1[7] = coef1_7;
		
		coef2[0] = coef2_0;
		coef2[1] = coef2_1;
		coef2[2] = coef2_2;
		coef2[3] = coef2_3;
		coef2[4] = coef2_4;
		coef2[5] = coef2_5;
		coef2[6] = coef2_6;
		coef2[7] = coef2_7;
		
		coef3[0] = coef3_0;
		coef3[1] = coef3_1;
		coef3[2] = coef3_2;
		coef3[3] = coef3_3;
		coef3[4] = coef3_4;
		coef3[5] = coef3_5;
		coef3[6] = coef3_6;
		coef3[7] = coef3_7;
	end
	
	
	//==========================================================
	// Sign extension part
	//==========================================================
	ama_dynamic_signed_function #(.width_data_in(width_coef),.width_data_out(width_data_out),.port_sign(port_sign))
	coef_ext_block_0(.data_in(coef0_wire), .sign(sign), .data_out(data_out_0));
	
	ama_dynamic_signed_function #(.width_data_in(width_coef),.width_data_out(width_data_out),.port_sign(port_sign))
	coef_ext_block_1(.data_in(coef1_wire), .sign(sign), .data_out(data_out_1));
	
	ama_dynamic_signed_function #(.width_data_in(width_coef),.width_data_out(width_data_out),.port_sign(port_sign))
	coef_ext_block_2(.data_in(coef2_wire), .sign(sign), .data_out(data_out_2));
	
	ama_dynamic_signed_function #(.width_data_in(width_coef),.width_data_out(width_data_out),.port_sign(port_sign))
	coef_ext_block_3(.data_in(coef3_wire), .sign(sign), .data_out(data_out_3));
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	ama_register_function #(.width_data_in(3),.width_data_out(3),.register_clock(register_clock_0),.register_aclr(register_aclr_0))
	coef_register_block_0(.clock(clock),.aclr(aclr),.ena(ena),.data_in(coefsel0),.data_out(coefsel0_reg_out));
	
	ama_register_function #(.width_data_in(3),.width_data_out(3),.register_clock(register_clock_1),.register_aclr(register_aclr_1))
	coef_register_block_1(.clock(clock),.aclr(aclr),.ena(ena),.data_in(coefsel1),.data_out(coefsel1_reg_out));
	
	ama_register_function #(.width_data_in(3),.width_data_out(3),.register_clock(register_clock_2),.register_aclr(register_aclr_2))
	coef_register_block_2(.clock(clock),.aclr(aclr),.ena(ena),.data_in(coefsel2),.data_out(coefsel2_reg_out));
	
	ama_register_function #(.width_data_in(3),.width_data_out(3),.register_clock(register_clock_3),.register_aclr(register_aclr_3))
	coef_register_block_3(.clock(clock),.aclr(aclr),.ena(ena),.data_in(coefsel3),.data_out(coefsel3_reg_out));
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Coef value selection and truncated into define width
	assign coef0_wire = coef0[coefsel0_reg_out];
	assign coef1_wire = coef1[coefsel1_reg_out];
	assign coef2_wire = coef2[coefsel2_reg_out];
	assign coef3_wire = coef3[coefsel3_reg_out];
	
	
	//==========================================================
	// Condition check
	//==========================================================
	initial /* synthesis enable_verilog_initial_construct */
		if( width_coef_ext != width_data_out)
		begin
			$display("Error: Function output width and assign output width not same. Happen in ama_coef_reg_ext_function function for altera_mult_add_rtl");
		end
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_adder_function
// Use in          : altera_mult_add_rtl
//
// Description     : Add input data with corresponding representation
//                     (data_in_0 + data_in_1) + (data_in_2 + data_in_3)
//--------------------------------------------------------------------------
module ama_adder_function (
	data_in_0,
	data_in_1,
	data_in_2,
	data_in_3,
	data_out,
	clock,
	aclr,
	ena,
	addnsub1,
	addnsub3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;             // Input data bus width
	parameter width_data_out = 1;            // Output data bus width
	parameter number_of_adder_input = 1;     // Total of data input to be add
	
	parameter adder1_direction = "NONE";   // First adder direction
	parameter adder3_direction = "NONE";   // Third adder direction
	
	parameter representation = "UNSIGNED";   // Representation for all the adder input
	
	parameter port_addnsub1 = "PORT_CONNECTIVITY";       // Input port addnsub1 parameter
	parameter addnsub_multiplier_register1 = "CLOCK0";   // Clock for addnsub1 signal register
	parameter addnsub_multiplier_aclr1 = "ACLR3";        // Aclr for addnsub1 signal register
	
	parameter port_addnsub3 = "PORT_CONNECTIVITY";       // Input port addnsub3 parameter
	parameter addnsub_multiplier_register3  = "CLOCK0";  // Clock for addnsub3 signal register
	parameter addnsub_multiplier_aclr3 = "ACLR3";        // Aclr for addnsub3 signal register
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;    // MSB for input data
	parameter width_data_out_msb = width_data_out -1;   // MSB for output data
	
	parameter width_adder_lvl_1 = width_data_in + 1;           // First level adder result width
	parameter width_adder_lvl_1_msb = width_adder_lvl_1 - 1;   // MSB for first level adder result
	
	parameter width_adder_lvl_2 = width_adder_lvl_1 + 1;       // Second level adder result width
	parameter width_adder_lvl_2_msb = width_adder_lvl_2 - 1;   // MSB for second level adder result
	
	parameter width_data_out_wire = width_data_in + 2;             // General adder result width
	parameter width_data_out_wire_msb = width_data_out_wire - 1;   // MSB for general adder result width
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Data input port define
	input [width_data_in_msb : 0] data_in_0, data_in_1, data_in_2, data_in_3;
	
	// Dynamic addnsub port define
	input addnsub1, addnsub3;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Adder input wire (with or without sign extension)
	wire signed [width_adder_lvl_1_msb : 0] data_in_ext_0, data_in_ext_1, data_in_ext_2, data_in_ext_3;
	
	// First level adder result wire
	wire signed [width_adder_lvl_1_msb : 0] adder_result_0, adder_result_1, adder_result_2, adder_result_3;

	// Second level adder result wire
	wire signed [width_adder_lvl_2_msb : 0] adder_result_ext_0, adder_result_ext_1, adder_result_ext_2, adder_result_ext_3;
	
	// General adder output wire
	wire [width_adder_lvl_2_msb : 0] data_out_wire;
	
	// Register addnsub wire
	wire addnsub1_wire, addnsub3_wire;
	
	//==========================================================
	// Assignment
	//==========================================================
	// First level adder assignment
	assign adder_result_0 = data_in_ext_0;
	
	assign adder_result_1 = (port_addnsub1 == "PORT_USED") ? (addnsub1_wire == 0) ? adder_result_0 - data_in_ext_1 : adder_result_0 + data_in_ext_1:
	                                                         (adder1_direction === "SUB") ? adder_result_0 - data_in_ext_1 : adder_result_0 + data_in_ext_1;
									
	assign adder_result_2 = data_in_ext_2; 
	
	assign adder_result_3 = (port_addnsub3 == "PORT_USED") ? (addnsub3_wire == 0) ? adder_result_2 - data_in_ext_3 : adder_result_2 + data_in_ext_3:
	                                                         (adder3_direction === "SUB") ? adder_result_2 - data_in_ext_3 : adder_result_2 + data_in_ext_3;
	
	// Output assignment (with second level adder assignment)
	assign data_out_wire = (number_of_adder_input == 1) ? adder_result_0 :
	                       (number_of_adder_input == 2) ? adder_result_1 :
	                       (number_of_adder_input == 3) ? adder_result_ext_1 + adder_result_ext_2 :
	                       (number_of_adder_input == 4) ? adder_result_ext_1 + adder_result_ext_3 :
	                       {width_data_out{1'bz}};
	
	// Output data assignmnet (with proper width assign)
	assign data_out = data_out_wire[width_data_out_msb : 0];
	
	
	//==========================================================
	// Sign extension
	//==========================================================
	// First level adder extension
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_data_in),.width_data_out(width_adder_lvl_1))
	first_adder_ext_block_0(.data_in(data_in_0),.data_out(data_in_ext_0));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_data_in),.width_data_out(width_adder_lvl_1))
	first_adder_ext_block_1(.data_in(data_in_1),.data_out(data_in_ext_1));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_data_in),.width_data_out(width_adder_lvl_1))
	first_adder_ext_block_2(.data_in(data_in_2),.data_out(data_in_ext_2));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_data_in),.width_data_out(width_adder_lvl_1))
	first_adder_ext_block_3(.data_in(data_in_3),.data_out(data_in_ext_3));
	
	// Second level adder extension
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_adder_lvl_1),.width_data_out(width_adder_lvl_2))
	second_adder_ext_block_0(.data_in(adder_result_0),.data_out(adder_result_ext_0));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_adder_lvl_1),.width_data_out(width_adder_lvl_2))
	second_adder_ext_block_1(.data_in(adder_result_1),.data_out(adder_result_ext_1));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_adder_lvl_1),.width_data_out(width_adder_lvl_2))
	second_adder_ext_block_2(.data_in(adder_result_2),.data_out(adder_result_ext_2));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_adder_lvl_1),.width_data_out(width_adder_lvl_2))
	second_adder_ext_block_3(.data_in(adder_result_3),.data_out(adder_result_ext_3));
	
	//==========================================================
	// Addnsub register part
	//==========================================================
	generate
		if (port_addnsub1 == "PORT_USED")
		begin
			ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(addnsub_multiplier_register1), .register_aclr(addnsub_multiplier_aclr1))
			addnsub_reg_block(.clock(clock),.aclr(aclr),.ena(ena), .data_in(addnsub1), .data_out(addnsub1_wire));
		end
		else
		begin
			assign addnsub1_wire = 1'b0;
		end
	endgenerate
	
	generate
		if (port_addnsub3 == "PORT_USED")
		begin
			ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(addnsub_multiplier_register3), .register_aclr(addnsub_multiplier_aclr3))
			addnsub_reg_block(.clock(clock),.aclr(aclr),.ena(ena), .data_in(addnsub3), .data_out(addnsub3_wire) );
		end
		else
		begin
			assign addnsub3_wire = 1'b0;
		end
	endgenerate

endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_multiplier_function
// Use in          : altera_mult_add_rtl
//
// Description     : Multiply input data with corresponding representation
//                     data_in_a * data_in_b
//--------------------------------------------------------------------------
module ama_multiplier_function (
	clock,
	aclr,
	ena,
	data_in_a0,
	data_in_a1,
	data_in_a2,
	data_in_a3,
	data_in_b0,
	data_in_b1,
	data_in_b2,
	data_in_b3,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in_a = 1;          // Input dataa bus width
	parameter width_data_in_b = 1;          // Input datab bus width
	parameter width_data_out = 1;           // Output data bus width
	parameter number_of_multipliers = 1;    // Total of data input to be multiply
	
	parameter multiplier_input_representation_a = "UNSIGNED";   // First multiplier input sign representation
	parameter multiplier_input_representation_b = "UNSIGNED";   // Second multiplier input sign representation
	
	parameter multiplier_register0 = "UNREGISTERED";   // First multiplier register clock
	parameter multiplier_register1 = "UNREGISTERED";   // Second multiplier register clock
	parameter multiplier_register2 = "UNREGISTERED";   // Third multiplier register clock
	parameter multiplier_register3 = "UNREGISTERED";   // Fourth multiplier register clock
	
	parameter multiplier_aclr0 = "NONE";   // First multiplier register aclr
	parameter multiplier_aclr1 = "NONE";   // Second multiplier register aclr
	parameter multiplier_aclr2 = "NONE";   // Third multiplier register aclr
	parameter multiplier_aclr3 = "NONE";   // Fourth multiplier register aclr
	
	// Internal used parameters
	parameter width_data_in_a_msb = width_data_in_a - 1;   // MSB for input dataa
	parameter width_data_in_b_msb = width_data_in_b - 1;   // MSB for input datab
	parameter width_data_out_msb = width_data_out -1;      // MSB for output data
	
	
	parameter width_mult_input_a = (multiplier_input_representation_a === "UNSIGNED") ? width_data_in_a + 1 :
                                                                                       width_data_in_a;   // Multiplier first input data
	parameter width_mult_input_a_msb = width_mult_input_a - 1;   // MSB for multiplier first input data
	
	parameter width_mult_input_b = (multiplier_input_representation_b === "UNSIGNED") ? width_data_in_b + 1 :
                                                                                       width_data_in_b;   // Multiplier second input data
	parameter width_mult_input_b_msb = width_mult_input_b - 1;   // MSB for multiplier second input data

	parameter width_mult_output = width_mult_input_a + width_mult_input_b;   // Calculated multiplier result width
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Data input port define
	input [width_data_in_a_msb : 0] data_in_a0, data_in_a1, data_in_a2, data_in_a3;
	input [width_data_in_b_msb : 0] data_in_b0, data_in_b1, data_in_b2, data_in_b3;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out_0, data_out_1, data_out_2, data_out_3;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Multiplier input wires (after extend or no extend)
	wire signed [width_mult_input_a_msb : 0] mult_input_a0, mult_input_a1, mult_input_a2, mult_input_a3;
	wire signed [width_mult_input_b_msb : 0] mult_input_b0, mult_input_b1, mult_input_b2, mult_input_b3;
	
	wire [width_data_out_msb : 0] data_out_wire_0, data_out_wire_1, data_out_wire_2, data_out_wire_3;
	
	//==========================================================
	// Assignment
	//==========================================================
	// Signed multiplier assignment
	assign data_out_wire_0 = mult_input_a0 * mult_input_b0;
	assign data_out_wire_1 = mult_input_a1 * mult_input_b1;
	assign data_out_wire_2 = mult_input_a2 * mult_input_b2;
	assign data_out_wire_3 = mult_input_a3 * mult_input_b3;
	
	
	//==========================================================
	// Sign extension
	//==========================================================
	// Multiplier input a extension
	ama_signed_extension_function #(.representation(multiplier_input_representation_a),.width_data_in(width_data_in_a),.width_data_out(width_mult_input_a))
	mult_input_a_ext_block_0(.data_in(data_in_a0),.data_out(mult_input_a0));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_a),.width_data_in(width_data_in_a),.width_data_out(width_mult_input_a))
	mult_input_a_ext_block_1(.data_in(data_in_a1),.data_out(mult_input_a1));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_a),.width_data_in(width_data_in_a),.width_data_out(width_mult_input_a))
	mult_input_a_ext_block_2(.data_in(data_in_a2),.data_out(mult_input_a2));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_a),.width_data_in(width_data_in_a),.width_data_out(width_mult_input_a))
	mult_input_a_ext_block_3(.data_in(data_in_a3),.data_out(mult_input_a3));
	
	// Multiplier input b extension
	ama_signed_extension_function #(.representation(multiplier_input_representation_b),.width_data_in(width_data_in_b),.width_data_out(width_mult_input_b))
	mult_input_b_ext_block_0(.data_in(data_in_b0),.data_out(mult_input_b0));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_b),.width_data_in(width_data_in_b),.width_data_out(width_mult_input_b))
	mult_input_b_ext_block_1(.data_in(data_in_b1),.data_out(mult_input_b1));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_b),.width_data_in(width_data_in_b),.width_data_out(width_mult_input_b))
	mult_input_b_ext_block_2(.data_in(data_in_b2),.data_out(mult_input_b2));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_b),.width_data_in(width_data_in_b),.width_data_out(width_mult_input_b))
	mult_input_b_ext_block_3(.data_in(data_in_b3),.data_out(mult_input_b3));
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	ama_register_function #(.width_data_in(width_data_out), .width_data_out(width_data_out), .register_clock(multiplier_register0), .register_aclr(multiplier_aclr0))
	multiplier_register_block_0(.clock(clock),.aclr(aclr),.ena(ena),.data_in(data_out_wire_0),.data_out(data_out_0));
	
	ama_register_function #(.width_data_in(width_data_out), .width_data_out(width_data_out), .register_clock(multiplier_register1), .register_aclr(multiplier_aclr1))
	multiplier_register_block_1(.clock(clock),.aclr(aclr),.ena(ena),.data_in(data_out_wire_1),.data_out(data_out_1));
	
	ama_register_function #(.width_data_in(width_data_out), .width_data_out(width_data_out), .register_clock(multiplier_register2), .register_aclr(multiplier_aclr2))
	multiplier_register_block_2(.clock(clock),.aclr(aclr),.ena(ena),.data_in(data_out_wire_2),.data_out(data_out_2));
	
	ama_register_function #(.width_data_in(width_data_out), .width_data_out(width_data_out), .register_clock(multiplier_register3), .register_aclr(multiplier_aclr3))
	multiplier_register_block_3(.clock(clock),.aclr(aclr),.ena(ena),.data_in(data_out_wire_3),.data_out(data_out_3));
	
	
	//==========================================================
	// Condition check
	//==========================================================
	initial /* synthesis enable_verilog_initial_construct */
		if( width_mult_output != width_data_out)
		begin
			$display("Error: Function output width and assign output width not same. Happen in ama_multiplier_function function for altera_mult_add_rtl");
		end
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_preadder_function
// Use in          : altera_mult_add_rtl
//
// Description     : Determine multiplier input source and contain pre-adder 
//                     for mode other that simple mode
//--------------------------------------------------------------------------
module ama_preadder_function (
	dataa_in_0,
	dataa_in_1,
	dataa_in_2,
	dataa_in_3,
	datab_in_0,
	datab_in_1,
	datab_in_2,
	datab_in_3,
	datac_in_0,
	datac_in_1,
	datac_in_2,
	datac_in_3,
	coef0,
	coef1,
	coef2,
	coef3,
	result_a0,
	result_a1,
	result_a2,
	result_a3,
	result_b0,
	result_b1,
	result_b2,
	result_b3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter preadder_mode  = "SIMPLE";   // Mode to determine output value
	
	parameter width_in_a  = 1;         // Dataa input bus width
	parameter width_in_b  = 1;         // Datab input bus width
	parameter width_in_c  = 1;         // Datac input bus width
	parameter width_in_coef  = 1;      // Coef input bus width
	
	parameter width_result_a = 1;   // Output result a bus width
	parameter width_result_b = 1;   // Output result b bus width
	
	parameter preadder_direction_0  = "ADD";   // First pre-adder direction
	parameter preadder_direction_1  = "ADD";   // Second pre-adder direction
	parameter preadder_direction_2  = "ADD";   // Third pre-adder direction
	parameter preadder_direction_3  = "ADD";   // Forth pre-adder direction
	
	parameter representation_preadder_adder = "UNSIGNED";   // Representation for pre-adder 
	
	// Internal used parameters
	parameter width_in_a_msb = width_in_a - 1;                 // MSB for dataa input
	parameter width_in_b_msb = width_in_b - 1;                 // MSB for datab input
	parameter width_in_c_msb = width_in_c - 1;                 // MSB for datav input
	parameter width_in_coef_msb = width_in_coef - 1;           // MSB for coef input
	parameter width_result_a_msb = width_result_a - 1;   // MSB for result a output
	parameter width_result_b_msb = width_result_b - 1;   // MSB for result b output
	
	parameter width_preadder_adder_input = (width_in_a > width_in_b) ? width_in_a : width_in_b;   // Determine pre-adder input width 
	parameter width_preadder_adder_input_msb = width_preadder_adder_input - 1;        // MSB for pre-adder input
	
	parameter width_preadder_adder_result = width_preadder_adder_input + 1;           // Pre-adder result width
	parameter width_preadder_adder_result_msb = width_preadder_adder_result - 1;      // MSB for pre-adder result
	
	parameter width_preadder_adder_input_wire = width_preadder_adder_input + 1;            // Pre-adder input width after extend
	parameter width_preadder_adder_input_wire_msb = width_preadder_adder_input_wire - 1;   // MSB for extended pre-adder input
	
	parameter width_in_a_ext = (width_preadder_adder_input > width_in_a) ? width_preadder_adder_input - width_in_a + 1 : 1;   // Width of dataa require to be extend
	parameter width_in_b_ext = (width_preadder_adder_input > width_in_b) ? width_preadder_adder_input - width_in_b + 1 : 1;   // Width of datab require to be extend
	
	parameter width_output_preadder = (preadder_mode === "SQUARE")? width_preadder_adder_result : 1;   // Prevent truncated warning happen
	parameter width_output_preadder_msb = width_output_preadder -1;

	parameter width_output_coef = (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? width_in_coef : 1;   // Prevent truncated warning happen
	parameter width_output_coef_msb = width_output_coef -1;
	
	parameter width_output_datab = (preadder_mode === "SIMPLE")? width_in_b : 1;   // Prevent truncated warning happen
	parameter width_output_datab_msb = width_output_datab -1;
	
	parameter width_output_datac = (preadder_mode === "INPUT")? width_in_c : 1;   // Prevent truncated warning happen
	parameter width_output_datac_msb = width_output_datac -1;
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input port define
	input [width_in_a_msb : 0] dataa_in_0, dataa_in_1, dataa_in_2, dataa_in_3;
	input [width_in_b_msb : 0] datab_in_0, datab_in_1, datab_in_2, datab_in_3;
	input [width_in_c_msb : 0] datac_in_0, datac_in_1, datac_in_2, datac_in_3;
	input [width_in_coef_msb : 0] coef0, coef1, coef2, coef3;
	
	// Data output port define
	output [width_result_a_msb : 0] result_a0, result_a1, result_a2, result_a3;
	output [width_result_b_msb : 0] result_b0, result_b1, result_b2, result_b3;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Pre-adder input wire
	wire [width_preadder_adder_input_msb : 0] preadder_input_a0, preadder_input_a1, preadder_input_a2, preadder_input_a3;
	wire [width_preadder_adder_input_msb : 0] preadder_input_b0, preadder_input_b1, preadder_input_b2, preadder_input_b3;
	
	// Pre-adder input wire (for concatenate)
	wire [width_preadder_adder_input_wire_msb : 0] preadder_input_wire_a0, preadder_input_wire_a1, preadder_input_wire_a2, preadder_input_wire_a3;
	wire [width_preadder_adder_input_wire_msb : 0] preadder_input_wire_b0, preadder_input_wire_b1, preadder_input_wire_b2, preadder_input_wire_b3;
	
	// Determine bits to be extend
	wire preadder_ext_a0 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : dataa_in_0[width_in_a_msb];
	wire preadder_ext_a1 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : dataa_in_1[width_in_a_msb];
	wire preadder_ext_a2 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : dataa_in_2[width_in_a_msb];
	wire preadder_ext_a3 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : dataa_in_3[width_in_a_msb];
	
	wire preadder_ext_b0 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : datab_in_0[width_in_b_msb];
	wire preadder_ext_b1 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : datab_in_1[width_in_b_msb];
	wire preadder_ext_b2 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : datab_in_2[width_in_b_msb];
	wire preadder_ext_b3 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : datab_in_3[width_in_b_msb];
	
	// Pre-adder result wire
	wire [width_preadder_adder_result_msb : 0] preadder_adder_result_0, preadder_adder_result_1, preadder_adder_result_2, preadder_adder_result_3;
	
	
	//==========================================================
	// Preadder adder (sum of 2)
	//==========================================================
	ama_adder_function #(.width_data_in(width_preadder_adder_input), .width_data_out(width_preadder_adder_result), .number_of_adder_input(2), .adder1_direction(preadder_direction_0), .representation(representation_preadder_adder))
	preadder_adder_0(.data_in_0(preadder_input_a0), .data_in_1(preadder_input_b0), .data_in_2(), .data_in_3(), .data_out(preadder_adder_result_0), .clock(), .aclr(), .ena(), .addnsub1(), .addnsub3());
	
	ama_adder_function #(.width_data_in(width_preadder_adder_input), .width_data_out(width_preadder_adder_result), .number_of_adder_input(2), .adder1_direction(preadder_direction_1), .representation(representation_preadder_adder))
	preadder_adder_1(.data_in_0(preadder_input_a1), .data_in_1(preadder_input_b1), .data_in_2(), .data_in_3(), .data_out(preadder_adder_result_1), .clock(), .aclr(), .ena(), .addnsub1(), .addnsub3());
	
	ama_adder_function #(.width_data_in(width_preadder_adder_input), .width_data_out(width_preadder_adder_result), .number_of_adder_input(2), .adder1_direction(preadder_direction_2), .representation(representation_preadder_adder))
	preadder_adder_2(.data_in_0(preadder_input_a2), .data_in_1(preadder_input_b2), .data_in_2(), .data_in_3(), .data_out(preadder_adder_result_2), .clock(), .aclr(), .ena(), .addnsub1(), .addnsub3());
	
	ama_adder_function #(.width_data_in(width_preadder_adder_input), .width_data_out(width_preadder_adder_result), .number_of_adder_input(2), .adder1_direction(preadder_direction_3), .representation(representation_preadder_adder))
	preadder_adder_3(.data_in_0(preadder_input_a3), .data_in_1(preadder_input_b3), .data_in_2(), .data_in_3(), .data_out(preadder_adder_result_3), .clock(), .aclr(), .ena(), .addnsub1(), .addnsub3());
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Preadder input extend (extra one bit, prevent zero concatenate issue)
	assign preadder_input_wire_a0 = {{width_in_a_ext{preadder_ext_a0}},dataa_in_0};
	assign preadder_input_wire_a1 = {{width_in_a_ext{preadder_ext_a1}},dataa_in_1};
	assign preadder_input_wire_a2 = {{width_in_a_ext{preadder_ext_a2}},dataa_in_2};
	assign preadder_input_wire_a3 = {{width_in_a_ext{preadder_ext_a3}},dataa_in_3};
	
	assign preadder_input_wire_b0 = {{width_in_b_ext{preadder_ext_b0}},datab_in_0};
	assign preadder_input_wire_b1 = {{width_in_b_ext{preadder_ext_b1}},datab_in_1};
	assign preadder_input_wire_b2 = {{width_in_b_ext{preadder_ext_b2}},datab_in_2};
	assign preadder_input_wire_b3 = {{width_in_b_ext{preadder_ext_b3}},datab_in_3};
	
	// Preadder input
	assign preadder_input_a0 = preadder_input_wire_a0[width_preadder_adder_input_msb : 0];
	assign preadder_input_a1 = preadder_input_wire_a1[width_preadder_adder_input_msb : 0];
	assign preadder_input_a2 = preadder_input_wire_a2[width_preadder_adder_input_msb : 0];
	assign preadder_input_a3 = preadder_input_wire_a3[width_preadder_adder_input_msb : 0];
	
	assign preadder_input_b0 = preadder_input_wire_b0[width_preadder_adder_input_msb : 0];
	assign preadder_input_b1 = preadder_input_wire_b1[width_preadder_adder_input_msb : 0];
	assign preadder_input_b2 = preadder_input_wire_b2[width_preadder_adder_input_msb : 0];
	assign preadder_input_b3 = preadder_input_wire_b3[width_preadder_adder_input_msb : 0];
	
	// Preadder output selection
	assign result_a0 = (preadder_mode != "SIMPLE" && preadder_mode != "CONSTANT") ? preadder_adder_result_0[width_result_a_msb : 0] :
	                                                                                dataa_in_0;
	assign result_a1 = (preadder_mode != "SIMPLE" && preadder_mode != "CONSTANT") ? preadder_adder_result_1[width_result_a_msb : 0] :
	                                                                                dataa_in_1;
	assign result_a2 = (preadder_mode != "SIMPLE" && preadder_mode != "CONSTANT") ? preadder_adder_result_2[width_result_a_msb : 0] :
	                                                                                dataa_in_2;
	assign result_a3 = (preadder_mode != "SIMPLE" && preadder_mode != "CONSTANT") ? preadder_adder_result_3[width_result_a_msb : 0] :
	                                                                                dataa_in_3;
	
	assign result_b0 = (preadder_mode === "INPUT")? datac_in_0[width_output_datac_msb : 0] :
		                (preadder_mode === "SQUARE")? preadder_adder_result_0[width_output_preadder_msb : 0] :
                      (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? coef0[width_output_coef_msb : 0] : 
                       datab_in_0[width_output_datab_msb : 0];
									
	assign result_b1 = (preadder_mode === "INPUT")? datac_in_1[width_output_datac_msb : 0] :
		                (preadder_mode === "SQUARE")? preadder_adder_result_1[width_output_preadder_msb : 0] :
                      (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? coef1[width_output_coef_msb : 0] : 
                       datab_in_1[width_output_datab_msb : 0];
									
	assign result_b2 = (preadder_mode === "INPUT")? datac_in_2[width_output_datac_msb : 0] :
		                (preadder_mode === "SQUARE")? preadder_adder_result_2[width_output_preadder_msb : 0] :
                      (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? coef2[width_output_coef_msb : 0] : 
                       datab_in_2[width_output_datab_msb : 0];
									
	assign result_b3 = (preadder_mode === "INPUT")? datac_in_3[width_output_datac_msb : 0] :
		                (preadder_mode === "SQUARE")? preadder_adder_result_3[width_output_preadder_msb : 0] :
                      (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? coef3[width_output_coef_msb : 0] : 
                       datab_in_3[width_output_datab_msb : 0];
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_accumulator_function
// Use in          : altera_mult_add_rtl
//
// Description     : Accumulate the result according to setting or direct
//                     output the current input result (when accumulator 
//                     equal to no)
//--------------------------------------------------------------------------
module ama_accumulator_function (
	clock,
	aclr,
	ena,
	accum_sload,
	sload_accum,
	data_result,
	prev_result,
	result
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_result = 1;            // Result bus width
	
	parameter accumulator = "NO";          // Allow result to be accumulated
	parameter accum_direction = "ADD";     // Accumulated by adding or substracting current result
	parameter loadconst_value = 0;         // Constant value to be add with current result
	
	parameter accum_sload_register = "UNREGISTERED";   // Clock for accum_sload signal register
	parameter accum_sload_aclr = "NONE";               // Aclr for accum_sload signal register
	
	parameter double_accum = "NO";         // Allow feedback result to be registered and form double channel (or double accumulator)
	parameter use_sload_accum_port = "NO";	// Use sload_accum port allow accumulator behavior to match the sv serries hardware architecture
	
	parameter output_register = "UNREGISTERED";   // Clock for output signal register
	parameter output_aclr = "NONE";               // Aclr for output signal register
	
	// Internal used parameters
	parameter width_result_msb = width_result - 1;   // MSB for  data
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Signal that select between loadconstant value or previous result for accumulate
	input accum_sload;
	input sload_accum;
	
	// Input data port define
	input [width_result_msb : 0] data_result;    // Current result
	input [width_result_msb : 0] prev_result;    // Previous result
	
	// Data output port define
	output [width_result_msb : 0] result;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Loadconst value that prepare to be added
	wire [width_result_msb : 0]loadconst_reg = {{width_result_msb{1'b0}},1'b1} << loadconst_value;
	
	// Contain the selection of previous result, between registered and unregistered value (for double accumulator)
	wire [width_result_msb : 0] prev_result_wire;
	
	// Registered accum_sload signal 
	wire accum_sload_wire;
	
	// Contain the value that need to accumulated with current result
	wire [width_result_msb : 0] accum_add_source;
	
	// Contain the accumulated result
	wire [width_result_msb : 0] accum_result;
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Accumulator (Double accumulator)
	
	// Accumulator source assignment
	generate if(use_sload_accum_port == "YES")
		begin
			assign accum_add_source = (accum_sload_wire == 1 && accum_sload_register !== "UNREGISTERED") ? prev_result_wire : loadconst_reg;
		end
	else
		begin
			assign accum_add_source = (accum_sload_wire == 1 && accum_sload_register !== "UNREGISTERED") ? loadconst_reg : prev_result_wire;
		end
	endgenerate
	
	// Accumulator result 
	assign accum_result = (accum_direction === "SUB") ? accum_add_source - data_result :
	                       accum_add_source + data_result;
	
	// Result assignment
	assign result = (accumulator === "NO") ? data_result : accum_result;
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================

	generate if(use_sload_accum_port == "YES")
		begin
			// sload_accum signal register
			ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(accum_sload_register), .register_aclr(accum_sload_aclr))
			accum_sload_register_block(.clock(clock), .aclr(aclr), .ena(ena), .data_in(sload_accum), .data_out(accum_sload_wire));
		end 
	else
		begin
			// Accum_sload signal register
			ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(accum_sload_register), .register_aclr(accum_sload_aclr))
			accum_sload_register_block(.clock(clock), .aclr(aclr), .ena(ena), .data_in(accum_sload), .data_out(accum_sload_wire));
		end
	endgenerate
	
	generate
		if (double_accum == "YES")
		begin
			ama_register_function #(.width_data_in(width_result), .width_data_out(width_result), .register_clock(output_register), .register_aclr(output_aclr))
			accum_sload_register_block(.clock(clock), .aclr(aclr), .ena(ena), .data_in(prev_result), .data_out(prev_result_wire));
		end
		else
		begin
			assign prev_result_wire = prev_result;
		end
	endgenerate
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_systolic_adder_function
// Use in          : altera_mult_add_rtl
//
// Description     : Contain systolic function 
//                   (((chainin + mult result 1)<reg> + mult result 2)<reg>
//                     + mult result 3)<reg> + mult result 4
//--------------------------------------------------------------------------
module ama_systolic_adder_function (
	data_in_0,
	data_in_1,
	data_in_2,
	data_in_3,
	chainin,
	clock,
	aclr,
	ena,
	data_out,
	addnsub1,
	addnsub3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;                   // Input data bus width
	parameter width_chainin  = 1;                  // Chainin data bus width
	parameter width_data_out = 1;                  // Output data bus width
	parameter number_of_adder_input = 1;           // Total of data input to be add
	
	parameter systolic_delay1 = "UNREGISTERED";    // Clock for first and second systolic register
	parameter systolic_aclr1 = "NONE";           // Aclr for first and second systolic register
	parameter systolic_delay3 = "UNREGISTERED";    // Clock for third systolic register
	parameter systolic_aclr3 = "NONE";           // Aclr for third systolic register
	
	parameter adder1_direction = "NONE";         // Second adder direction 
	parameter adder3_direction = "NONE";         // Forth adder direction
	
	parameter port_addnsub1 = "PORT_CONNECTIVITY";       // Input port addnsub1 parameter
	parameter addnsub_multiplier_register1 = "CLOCK0";   // Clock for addnsub1 signal register
	parameter addnsub_multiplier_aclr1 = "ACLR3";        // Aclr for addnsub1 signal register
	
	parameter port_addnsub3 = "PORT_CONNECTIVITY";       // Input port addnsub3 parameter
	parameter addnsub_multiplier_register3  = "CLOCK0";  // Clock for addnsub3 signal register
	parameter addnsub_multiplier_aclr3 = "ACLR3";        // Aclr for addnsub3 signal register
	
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;     // MSB for input data
	parameter width_data_out_msb = width_data_out -1;    // MSB for output data
	parameter width_chainin_msb = width_chainin -1;      // MSB for chainin data

	parameter width_systolic = (width_chainin > width_data_in) ? width_chainin : width_data_in;   // Width of adder data input and result
	parameter width_systolic_msb = width_systolic - 1;    // MSB for systolic ext

	parameter input_ext_width = (width_chainin > width_data_in) ? width_chainin - width_data_in : 1;   // Extend input data to be same as chainin width
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input port define
	input [width_data_in_msb : 0] data_in_0, data_in_1, data_in_2, data_in_3;
	
	// Chainin input port define
	input [width_chainin_msb : 0] chainin;   
	
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic addnsub port define
	input addnsub1, addnsub3;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Input data extension wire
	wire signed [width_systolic_msb : 0] data_in_ext_0, data_in_ext_1, data_in_ext_2, data_in_ext_3;
	
	// Adder registered result wire
	wire signed [width_systolic_msb : 0] adder_result_reg_0, adder_result_reg_1, adder_result_reg_2;
	
	// Adder result wire
	wire signed [width_systolic_msb : 0] adder_result_0, adder_result_1, adder_result_2, adder_result_3;
	
	// Register addnsub wire
	wire addnsub1_wire, addnsub3_wire;
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Input data extension
	assign data_in_ext_0 = {{input_ext_width{data_in_0[width_data_in_msb]}},data_in_0};
	assign data_in_ext_1 = {{input_ext_width{data_in_1[width_data_in_msb]}},data_in_1};
	assign data_in_ext_2 = {{input_ext_width{data_in_2[width_data_in_msb]}},data_in_2};
	assign data_in_ext_3 = {{input_ext_width{data_in_3[width_data_in_msb]}},data_in_3};
	
	// Adder assignment
	assign adder_result_0 = chainin + data_in_ext_0;
	assign adder_result_1 = (port_addnsub1 == "PORT_USED") ? (addnsub1_wire == 0) ? adder_result_reg_0 - data_in_ext_1 : adder_result_reg_0 + data_in_ext_1:
	                                                         (adder1_direction === "SUB") ? adder_result_reg_0 - data_in_ext_1 : adder_result_reg_0 + data_in_ext_1;
	assign adder_result_2 = adder_result_reg_1 + data_in_ext_2;
	assign adder_result_3 = (port_addnsub3 == "PORT_USED") ? (addnsub3_wire == 0) ? adder_result_reg_2 - data_in_ext_3 : adder_result_reg_2 + data_in_ext_3:
	                                                         (adder3_direction === "SUB") ? adder_result_reg_2 - data_in_ext_3 : adder_result_reg_2 + data_in_ext_3;
	
	// Ouptut result selection
	assign data_out = (number_of_adder_input == 1) ? adder_result_0[width_data_out_msb : 0] : 
	                  (number_of_adder_input == 2) ? adder_result_1[width_data_out_msb : 0] : 
							(number_of_adder_input == 3) ? adder_result_2[width_data_out_msb : 0] : 
							(number_of_adder_input == 4) ? adder_result_3[width_data_out_msb : 0] : {width_data_out{1'bx}};
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	// First register (adder result for chainin and first input data) 
	ama_register_function #(.width_data_in(width_systolic), .width_data_out(width_systolic), .register_clock(systolic_delay1), .register_aclr(systolic_aclr1))
	systolic_reg_block_0(.clock(clock), .aclr(aclr), .ena(ena), .data_in(adder_result_0), .data_out(adder_result_reg_0));
	
	// Second register (for first adder result and second input data) 
	ama_register_function #(.width_data_in(width_systolic), .width_data_out(width_systolic), .register_clock(systolic_delay1), .register_aclr(systolic_aclr1))
	systolic_reg_block_1(.clock(clock), .aclr(aclr), .ena(ena), .data_in(adder_result_1), .data_out(adder_result_reg_1));
	
	// Third register (for second adder result and third input data) 
	ama_register_function #(.width_data_in(width_systolic), .width_data_out(width_systolic), .register_clock(systolic_delay3), .register_aclr(systolic_aclr3))
	systolic_reg_block_2(.clock(clock), .aclr(aclr), .ena(ena), .data_in(adder_result_2), .data_out(adder_result_reg_2));
	
	
	//==========================================================
	// Addnsub register part
	//==========================================================
	generate
		if (port_addnsub1 == "PORT_USED")
		begin
			ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(addnsub_multiplier_register1), .register_aclr(addnsub_multiplier_aclr1))
			addnsub_reg_block(.clock(clock),.aclr(aclr),.ena(ena), .data_in(addnsub1), .data_out(addnsub1_wire));
		end
		else
		begin
			assign addnsub1_wire = 1'b0;
		end
	endgenerate
	
	generate
		if (port_addnsub3 == "PORT_USED")
		begin
			ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(addnsub_multiplier_register3), .register_aclr(addnsub_multiplier_aclr3))
			addnsub_reg_block(.clock(clock),.aclr(aclr),.ena(ena), .data_in(addnsub3), .data_out(addnsub3_wire) );
		end
		else
		begin
			assign addnsub3_wire = 1'b0;
		end
	endgenerate
	
endmodule

//--------------------------------------------------------------------------
// Module Name     : ama_data_split_reg_ext_function
// Use in          : altera_mult_add_rtl
//
// Description     : Split data evenly according to the number of multiplier
//--------------------------------------------------------------------------
module ama_scanchain (
	clock,
	aclr,
	ena,
	sign,
	scanin,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3,
	scanout
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_scanin = 1;                    // Scanin data bus width
	parameter width_scanchain = 1;                 // Scanchain data bus width
	
	parameter input_register_clock_0 = "UNREGISTERED";    // Clock for first data output register
	parameter input_register_aclr_0  = "NONE";          // Aclr for first data output register
	parameter input_register_clock_1 = "UNREGISTERED";    // Clock for second data output register
	parameter input_register_aclr_1  = "NONE";          // Aclr for second data output register
	parameter input_register_clock_2 = "UNREGISTERED";    // Clock for third data output register
	parameter input_register_aclr_2  = "NONE";          // Aclr for third data output register
	parameter input_register_clock_3 = "UNREGISTERED";    // Clock for fourth data output register
	parameter input_register_aclr_3  = "NONE";          // Aclr for fourth data output register
	
	parameter scanchain_register_clock = "UNREGISTERED";    // Clock for scanchain data register
	parameter scanchain_register_aclr = "NONE";           // Aclr for scanchain data register
	
	parameter port_sign = "PORT_CONNECTIVITY";      // Dynamic sign extension port condition
	parameter number_of_multipliers = 1;            // Total number of data going to be splited 
	
	// Internal used parameters
	parameter width_scanin_msb = width_scanin - 1;         // MSB of input data
	parameter width_scanchain_msb = width_scanchain -1;    // MSB of output data
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic sign port define
	input sign;
	
	// Data input port define
	input [width_scanin_msb : 0] scanin;
	
	// Data output port define
	output [width_scanchain_msb : 0] data_out_0, data_out_1, data_out_2, data_out_3, scanout;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Split data after registered and dynamic extension
	wire [width_scanchain_msb : 0] scanchain_wire_0, scanchain_wire_1, scanchain_wire_2, scanchain_wire_3;
	wire [width_scanchain_msb : 0] scanchain_reg_wire_0, scanchain_reg_wire_1, scanchain_reg_wire_2, scanchain_reg_wire_3;
	wire [width_scanchain_msb : 0] scanout_reg_wire;
	
	//==========================================================
	// Assignment
	//==========================================================
	// Data output assignment
	assign data_out_0 = scanchain_reg_wire_0;
	assign data_out_1 = (number_of_multipliers >= 2)? scanchain_reg_wire_1 : {(width_scanchain ){1'bx}};
	assign data_out_2 = (number_of_multipliers >= 3)? scanchain_reg_wire_2 : {(width_scanchain ){1'bx}};
	assign data_out_3 = (number_of_multipliers == 4)? scanchain_reg_wire_3 : {(width_scanchain ){1'bx}};
	
	assign scanout_reg_wire = (number_of_multipliers == 2)? scanchain_reg_wire_1 :
	                          (number_of_multipliers == 3)? scanchain_reg_wire_2 :
	                          (number_of_multipliers == 4)? scanchain_reg_wire_3 :
	                          scanchain_reg_wire_0;
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	// Scanchain register part
	// Only extend one time for dynamic sign extension
	ama_register_with_ext_function #(.width_data_in(width_scanin), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr), .port_sign(port_sign))
	scanchain_register_block_0(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(scanin), .data_out(scanchain_wire_0));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr))
	scanchain_register_block_1(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_reg_wire_0), .data_out(scanchain_wire_1));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr))
	scanchain_register_block_2(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_reg_wire_1), .data_out(scanchain_wire_2));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr))
	scanchain_register_block_3(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_reg_wire_2), .data_out(scanchain_wire_3));
	
	
	// Input register part
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(input_register_clock_0), .register_aclr(input_register_aclr_0))
	input_register_block_0(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_wire_0), .data_out(scanchain_reg_wire_0));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(input_register_clock_1), .register_aclr(input_register_aclr_1))
	input_register_block_1(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_wire_1), .data_out(scanchain_reg_wire_1));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(input_register_clock_2), .register_aclr(input_register_aclr_2))
	input_register_block_2(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_wire_2), .data_out(scanchain_reg_wire_2));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(input_register_clock_3), .register_aclr(input_register_aclr_3))
	input_register_block_3(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_wire_3), .data_out(scanchain_reg_wire_3));
	
	
	// Scanout register part
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr))
	scanout_register_block(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanout_reg_wire), .data_out(scanout));
	
endmodule
// (C) 2001-2010 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

`timescale 1 ps/1 ps
module altera_pll_reconfig_tasks
#(
    //parameter
    parameter number_of_fplls = 1
)();

task set_pll_m_cnt_hi_div_setting;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] pll_m_cnt_hi_div_setting[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_m_cnt_hi_div_setting[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_m_cnt_hi_div_setting[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_m_cnt_lo_div_setting;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] pll_m_cnt_lo_div_setting[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_m_cnt_lo_div_setting[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_m_cnt_lo_div_setting[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_m_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg pll_m_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_m_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_m_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_m_cnt_odd_div_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg pll_m_cnt_odd_div_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_m_cnt_odd_div_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_m_cnt_odd_div_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_n_cnt_hi_div_setting;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] pll_n_cnt_hi_div_setting[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_n_cnt_hi_div_setting[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_n_cnt_hi_div_setting[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_n_cnt_lo_div_setting;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] pll_n_cnt_lo_div_setting[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_n_cnt_lo_div_setting[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_n_cnt_lo_div_setting[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_n_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg pll_n_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_n_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_n_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_n_cnt_odd_div_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg pll_n_cnt_odd_div_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_n_cnt_odd_div_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_n_cnt_odd_div_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_fractional_value_ready;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg pll_fractional_value_ready[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_fractional_value_ready[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_fractional_value_ready[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_fractional_division_setting;
	input read_data;
	input [4:0] fractional_pll_index;
	input [31:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [31:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [31:0] pll_fractional_division_setting[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_fractional_division_setting[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_fractional_division_setting[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_dsm_dither;
	input read_data;
	input [4:0] fractional_pll_index;
	input [1:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [1:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [1:0] pll_dsm_dither[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_dsm_dither[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_dsm_dither[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_dsm_out_sel;
	input read_data;
	input [4:0] fractional_pll_index;
	input [1:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [1:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [1:0] pll_dsm_out_sel[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_dsm_out_sel[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_dsm_out_sel[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_bwctrl;
	input read_data;
	input [4:0] fractional_pll_index;
	input [3:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [3:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [3:0] pll_bwctrl[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_bwctrl[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_bwctrl[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_pll_cp_current;
	input read_data;
	input [4:0] fractional_pll_index;
	input [2:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [3:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [2:0] pll_cp_current[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = pll_cp_current[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			pll_cp_current[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter0_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter0_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter0_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter0_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter0_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter0_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter0_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter0_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter0_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter0_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter0_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter0_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter0_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter0_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter0_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter0_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter1_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter1_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter1_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter1_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter1_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter1_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter1_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter1_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter1_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter1_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter1_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter1_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter1_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter1_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter1_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter1_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter2_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter2_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter2_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter2_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter2_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter2_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter2_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter2_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter2_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter2_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter2_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter2_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter2_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter2_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter2_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter2_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter3_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter3_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter3_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter3_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter3_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter3_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter3_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter3_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter3_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter3_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter3_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter3_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter3_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter3_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter3_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter3_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter4_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter4_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter4_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter4_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter4_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter4_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter4_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter4_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter4_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter4_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter4_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter4_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter4_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter4_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter4_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter4_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter5_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter5_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter5_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter5_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter5_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter5_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter5_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter5_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter5_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter5_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter5_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter5_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter5_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter5_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter5_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter5_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter6_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter6_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter6_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter6_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter6_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter6_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter6_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter6_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter6_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter6_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter6_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter6_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter6_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter6_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter6_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter6_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter7_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter7_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter7_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter7_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter7_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter7_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter7_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter7_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter7_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter7_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter7_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter7_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter7_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter7_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter7_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter7_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter8_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter8_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter8_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter8_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter8_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter8_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter8_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter8_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter8_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter8_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter8_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter8_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter8_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter8_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter8_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter8_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter9_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter9_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter9_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter9_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter9_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter9_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter9_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter9_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter9_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter9_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter9_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter9_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter9_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter9_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter9_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter9_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter10_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter10_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter10_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter10_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter10_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter10_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter10_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter10_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter10_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter10_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter10_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter10_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter10_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter10_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter10_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter10_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter11_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter11_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter11_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter11_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter11_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter11_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter11_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter11_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter11_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter11_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter11_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter11_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter11_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter11_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter11_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter11_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter12_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter12_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter12_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter12_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter12_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter12_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter12_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter12_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter12_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter12_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter12_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter12_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter12_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter12_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter12_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter12_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter13_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter13_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter13_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter13_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter13_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter13_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter13_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter13_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter13_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter13_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter13_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter13_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter13_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter13_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter13_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter13_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter14_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter14_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter14_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter14_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter14_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter14_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter14_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter14_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter14_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter14_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter14_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter14_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter14_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter14_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter14_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter14_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter15_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter15_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter15_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter15_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter15_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter15_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter15_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter15_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter15_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter15_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter15_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter15_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter15_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter15_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter15_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter15_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter16_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter16_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter16_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter16_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter16_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter16_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter16_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter16_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter16_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter16_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter16_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter16_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter16_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter16_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter16_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter16_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter17_dprio0_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter17_dprio0_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter17_dprio0_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter17_dprio0_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter17_dprio0_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter17_dprio0_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter17_dprio0_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter17_dprio0_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter17_dprio0_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter17_dprio0_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter17_dprio0_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter17_dprio0_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter17_dprio0_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter17_dprio0_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter17_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter17_dprio0_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter0_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter0_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter0_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter0_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter0_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter0_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter0_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter0_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter0_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter0_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter0_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter0_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter0_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter0_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter0_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter0_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter1_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter1_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter1_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter1_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter1_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter1_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter1_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter1_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter1_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter1_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter1_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter1_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter1_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter1_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter1_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter1_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter2_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter2_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter2_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter2_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter2_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter2_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter2_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter2_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter2_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter2_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter2_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter2_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter2_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter2_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter2_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter2_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter3_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter3_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter3_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter3_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter3_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter3_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter3_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter3_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter3_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter3_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter3_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter3_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter3_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter3_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter3_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter3_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter4_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter4_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter4_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter4_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter4_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter4_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter4_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter4_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter4_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter4_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter4_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter4_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter4_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter4_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter4_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter4_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter5_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter5_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter5_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter5_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter5_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter5_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter5_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter5_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter5_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter5_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter5_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter5_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter5_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter5_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter5_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter5_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter6_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter6_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter6_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter6_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter6_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter6_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter6_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter6_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter6_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter6_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter6_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter6_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter6_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter6_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter6_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter6_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter7_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter7_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter7_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter7_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter7_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter7_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter7_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter7_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter7_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter7_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter7_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter7_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter7_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter7_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter7_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter7_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter8_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter8_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter8_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter8_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter8_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter8_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter8_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter8_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter8_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter8_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter8_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter8_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter8_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter8_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter8_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter8_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter9_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter9_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter9_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter9_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter9_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter9_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter9_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter9_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter9_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter9_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter9_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter9_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter9_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter9_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter9_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter9_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter10_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter10_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter10_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter10_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter10_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter10_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter10_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter10_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter10_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter10_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter10_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter10_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter10_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter10_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter10_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter10_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter11_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter11_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter11_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter11_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter11_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter11_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter11_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter11_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter11_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter11_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter11_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter11_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter11_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter11_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter11_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter11_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter12_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter12_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter12_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter12_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter12_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter12_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter12_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter12_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter12_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter12_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter12_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter12_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter12_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter12_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter12_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter12_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter13_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter13_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter13_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter13_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter13_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter13_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter13_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter13_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter13_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter13_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter13_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter13_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter13_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter13_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter13_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter13_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter14_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter14_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter14_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter14_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter14_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter14_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter14_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter14_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter14_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter14_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter14_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter14_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter14_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter14_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter14_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter14_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter15_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter15_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter15_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter15_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter15_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter15_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter15_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter15_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter15_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter15_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter15_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter15_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter15_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter15_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter15_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter15_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter16_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter16_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter16_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter16_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter16_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter16_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter16_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter16_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter16_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter16_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter16_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter16_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter16_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter16_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter16_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter16_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter17_dprio1_cnt_hi_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter17_dprio1_cnt_hi_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter17_dprio1_cnt_hi_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter17_dprio1_cnt_hi_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter17_dprio1_cnt_lo_div;
	input read_data;
	input [4:0] fractional_pll_index;
	input [7:0] input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output [7:0] output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg [7:0] counter17_dprio1_cnt_lo_div[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter17_dprio1_cnt_lo_div[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter17_dprio1_cnt_lo_div[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter17_dprio1_cnt_bypass_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter17_dprio1_cnt_bypass_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter17_dprio1_cnt_bypass_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter17_dprio1_cnt_bypass_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask
task set_counter17_dprio1_cnt_odd_div_even_duty_en;
	input read_data;
	input [4:0] fractional_pll_index;
	input input_data;
	input iocsr_en_input;
	input mdio_dis_input;
	input fpll_0_input;
	output output_data;
	output iocsr_en_output;
	output mdio_dis_output;
	output fpll_0_output;
	reg counter17_dprio1_cnt_odd_div_even_duty_en[number_of_fplls-1:0];
	reg iocsr_en[number_of_fplls-1:0];
	reg mdio_dis[number_of_fplls-1:0];
	reg fpll_0[number_of_fplls-1:0];

	begin
		if (read_data == 1'b1) begin
			output_data = counter17_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index];
			iocsr_en_output = iocsr_en[fractional_pll_index];
			mdio_dis_output = mdio_dis[fractional_pll_index];
			fpll_0_output = fpll_0[fractional_pll_index];
		end
		else begin
			counter17_dprio1_cnt_odd_div_even_duty_en[fractional_pll_index] = input_data;
			iocsr_en[fractional_pll_index] = iocsr_en_input;
			mdio_dis[fractional_pll_index] = mdio_dis_input;
			fpll_0[fractional_pll_index] = fpll_0_input;
		end
	end
endtask

endmodule
