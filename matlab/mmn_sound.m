classdef mmn_sound < mmn
    properties
        Fs
        wavStandard
        wavDeviant
    end
    methods
        function obj = mmn_sound(tSOA, tDur, numStimuli, pDeviant)
            % super constructor
            obj@mmn(tSOA, tDur, numStimuli, pDeviant);
            
            obj.Fs = 44100;
            obj.wavStandard = mmn_sound.lcf_Tone(500, obj.tDur, obj.Fs);
            obj.wavDeviant = mmn_sound.lcf_Tone(800, obj.tDur, obj.Fs);

        end
        
        function presentStandard(obj)
            sound(obj.wavStandard, obj.Fs);
        end
        
        function presentDeviant(obj)
            sound(obj.wavDeviant, obj.Fs);
        end
    end
    
    methods(Static)
        function out = lcf_Tone(freq, SDur, Fs)
            t = 0:1/Fs:SDur; % time axis
            y = sin(2 * pi * freq * t);
            rcos = 0.5 - 0.5 * cos(linspace(0, pi, 0.05 * Fs)); % 50ms raised cosine window
            out = y .* [rcos ones(1, length(y) - length(rcos) * 2) fliplr(rcos)];
        end
    end
end
