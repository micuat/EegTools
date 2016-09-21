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
            assert(pDeviant > 0 && pDeviant < 0.5);
            
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
            
            meanStandardsInRow = int32((1 - obj.pDeviant) / obj.pDeviant);
            minStandardsInRow = meanStandardsInRow / 2;
            maxStandardsInRow = meanStandardsInRow * 3 / 2;
            nextDeviant = 1 + randi([minStandardsInRow maxStandardsInRow]);
            
            verificationArray = zeros(1, obj.numStimuli);
            for i = 1:obj.numStimuli
                disp(i);
                if i == nextDeviant
                    obj.outlet.push_sample({'Deviant'});
                    presentDeviant(obj);
                    verificationArray(i) = 1;
                    
                    nextDeviant = i + 1 + randi([minStandardsInRow maxStandardsInRow]);
                else
                    obj.outlet.push_sample({'Standard'});
                    presentStandard(obj);
                end
                pause(obj.tDur);
                
                presentBreak(obj);
                pause(obj.tISI);
            end
            
            disp(sum(verificationArray) / length(verificationArray));
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
