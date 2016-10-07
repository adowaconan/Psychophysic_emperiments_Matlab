function [Gabor] = GaborMaking(angle, xbound, ybound, numberOfPoints)
sf = 10;
angle = 90 - angle;
[X, Y] = meshgrid(linspace(xbound, ybound,numberOfPoints));

% Gaussian envelope
Gaussian = exp(-X.^ 2-Y.^2);
% Bar grids
[X, Y] = meshgrid(linspace(-pi,pi, numberOfPoints));
ramp = cos(angle*pi/180)*X - sin(angle*pi/180)*Y;
orientedGrating = sin(sf* ramp);
Gabor = Gaussian .* orientedGrating;
