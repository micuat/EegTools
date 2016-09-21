classdef mmn_shapes < mmn
    properties
        % screen resolution
        H = 768;
        W = 1366;
        
        h
        w
        circle_diameter
        square_halfedge
        square_edge
        
        square
        circle
        blank
    end
    methods
        function obj = mmn_shapes(tSOA, tDur, numStimuli, pDeviant)
            % super constructor
            obj@mmn(tSOA, tDur, numStimuli, pDeviant);
            
            % manually find some parameters to fit to screen
            obj.h = int32(obj.H * 0.7);
            obj.w = int32(obj.W * 0.7);

            obj.circle_diameter = obj.h * 0.5 * 0.75;
            obj.square_halfedge = obj.h * 0.5 * 0.75;
            obj.square_edge = obj.square_halfedge * 2;
            
            % prepare shapes
            [x y] = meshgrid(1:obj.w, 1:obj.h);
            obj.circle = (x - obj.w * 0.5) .* (x - obj.w * 0.5) + (y - obj.h * 0.5) .* (y - obj.h * 0.5);
            obj.circle = obj.circle < obj.circle_diameter * obj.circle_diameter;

            squarex = abs(x - obj.w * 0.5) < obj.square_halfedge;
            squarey = abs(y - obj.h * 0.5) < obj.square_halfedge;
            obj.square = squarex & squarey;
            
            obj.blank = zeros(obj.h, obj.w);
        end
        
        function presentPreExperiment(obj)
            imshow(obj.blank);
            disp('please press a key');
        end
        
        function presentStandard(obj)
            imshow(obj.square);
        end
        
        function presentDeviant(obj)
            imshow(obj.circle);
        end
        
        function presentBreak(obj)
            imshow(obj.blank);
        end
    end
end
