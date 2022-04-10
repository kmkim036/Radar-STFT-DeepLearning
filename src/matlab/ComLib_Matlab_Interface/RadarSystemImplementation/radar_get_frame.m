function [I, Q] = radar_get_frame(serialPortHandle)
% Returns  Line vector of I and Q raw data from Sense2GoL device received via UART

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2014-2018, Infineon Technologies AG
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,are permitted provided that the
% following conditions are met:
%
% Redistributions of source code must retain the above copyright notice, this list of conditions and the following
% disclaimer.
%
% Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
% disclaimer in the documentation and/or other materials provided with the distribution.
%
% Neither the name of the copyright holders nor the names of its contributors may be used to endorse or promote
% products derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE  FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
% WHETHER IN CONTRACT, STRICT LIABILITY,OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Date: 29.12.2017
%%% Author: Finke
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NUMBER_SAMPLES = 128;
UART_NUMBER_VALUES_PER_LINE = 16;

% skip text information before begin of data
s = fgets(serialPortHandle);
while isempty(strfind(s, 'I raw samples'))
    s = fgets(serialPortHandle);
end

% extract I data
I = [];
for i = 1:NUMBER_SAMPLES/UART_NUMBER_VALUES_PER_LINE
    s = fgets(serialPortHandle);
    
    S = str2num(s);
    
    if size(I, 1) == 0
        I = S;
    else
        I = [I S];
    end
end

while isempty(strfind(s, 'Q raw samples'));
    s = fgets(serialPortHandle);
end

sizeI = size(I,2);
if sizeI < NUMBER_SAMPLES
    I = [I zeros(1, NUMBER_SAMPLES - sizeI)]; 
elseif sizeI > NUMBER_SAMPLES
    I = I(1,1:NUMBER_SAMPLES);
end

% extract Q data
Q = [];
for q = 1:NUMBER_SAMPLES/UART_NUMBER_VALUES_PER_LINE
    s = fgets(serialPortHandle);
    
    S = str2num(s);
    
    if size(Q, 1) == 0
        Q = [S];
    else
        Q = [Q S];
    end
end

sizeQ = size(Q,2);
if sizeQ < NUMBER_SAMPLES
    Q = [Q zeros(1, NUMBER_SAMPLES - sizeQ)]; 
elseif sizeQ > NUMBER_SAMPLES
    Q = Q(1,1:NUMBER_SAMPLES);
end

% convert column vector to line vector
I = I';
Q = Q';

end