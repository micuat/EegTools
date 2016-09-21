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
            presentPreExperiment(obj);
            while waitforbuttonpress ~= 1
            end
            
            for i = 1:obj.numStimuli
                disp(i);
                index = (rand < 0.8);
                if index == 1
                    obj.outlet.push_sample({'Standard'});
                    presentStandard(obj);
                else
                    obj.outlet.push_sample({'Deviant'});
                    presentDeviant(obj);
                end
                pause(obj.tDur);
                
                presentBreak(obj);
                pause(obj.tISI);
            end
        end
        
        function presentPreExperiment(obj)
            disp('please press a key');
        end
        
        function presentStandard(obj)
            disp('presenting standard stimulus');
        end
        
        function presentDeviant(obj)
            disp('presenting deviant stimulus');
        end
        
        function presentBreak(obj)
        end
    end
end
