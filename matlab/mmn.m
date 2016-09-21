classdef mmn
    properties
        tSOA
        tDur
        numStimuli
        pDeviant
        
        % LSL
        lib
        info
        outlet
    end
    methods
        function obj = mmn(tSOA, tDur, numStimuli, pDeviant)
            obj.tSOA = tSOA;
            obj.tDur = tDur;
            obj.numStimuli = numStimuli;
            obj.pDeviant = pDeviant;
            
            assert(tSOA > tDur);
            assert(pDeviant > 0 && pDeviant < 1);
            
            % LSL Init Begin
            % instantiate the library
            disp('Loading library...');
            obj.lib = lsl_loadlib();

            % make a new stream outlet
            disp('Creating a new streaminfo...');
            obj.info = lsl_streaminfo(obj.lib,'MatlabStimuli','Markers',1,1/tSOA,'cf_string','stimuliID');

            disp('Opening an outlet...');
            obj.outlet = lsl_outlet(obj.info);
            % LSL Init End
        end
        
        % return interstimulus interval
        function t = tISI(obj)
            t = obj.tSOA - obj.tDur;
        end
        
        % start experiment
        function start(obj)
            figure(1)
            while waitforbuttonpress ~= 1
            end
            
            for i = 1:obj.numStimuli
                disp(i);
                index = (rand < 0.8);
                if index == 0
                    obj.outlet.push_sample({'Standard'});
                    presentStandard(obj);
                else
                    obj.outlet.push_sample({'Deviant'});
                    presentDeviant(obj);
                end
                
                presentBreak(obj);
            end
        end
        
        function presentStandard(obj)
            disp('presenting standard stimulus');
            pause(obj.tDur);
        end
        
        function presentDeviant(obj)
            disp('presenting deviant stimulus');
            pause(obj.tDur);
        end
        
        function presentBreak(obj)
            disp('a short break');
            pause(obj.tISI);
        end
    end
end
