#!/usr/bin/env octave

clear all
close all
clc

[NELEM_PML_THICKNESSStatus NELEM_PML_THICKNESS] = system('grep NELEM_PML_THICKNESS ../backup/Par_file_part | cut -d = -f 2');
NELEM_PML_THICKNESS = str2num(NELEM_PML_THICKNESS);

[xminStatus xmin] = system('grep xmin ../backup/Par_file_part | cut -d = -f 2');
xmin = str2num(xmin);

[xmaxStatus xmax] = system('grep xmax ../backup/Par_file_part | cut -d = -f 2');
xmax = str2num(xmax);

[nxStatus nx] = system('grep nx ../backup/Par_file_part | cut -d = -f 2');
nx = str2num(nx);
xNumber = nx + 1;

dx = (xmax - xmin)/nx;
dz = dx;
nz_offset = 4*NELEM_PML_THICKNESS;
nz = nx+nz_offset;

x=linspace(xmin,xmax,xNumber);

zmin = 0 - nz_offset*dz;
zmax = xmax-xmin;

fileID = fopen(['../backup/mesh_info'],'w');
  fprintf(fileID, '%f %f %i %f %f %i',xmin,xmax,nx,zmin,zmax,nz)
fclose(fileID);

interfaces = [zmin zmax];

layers = [nz];

subInterfaces = repmat(transpose(interfaces),[1,xNumber]);

%subInterfaces(end,:) = interp1(TOPO_slice(1,:),TOPO_slice(2,:),x);

fileID = fopen(['../DATA/interfaces.dat'],'w');
fprintf(fileID, '%i\n', length(interfaces))
fprintf(fileID, '%s\n', '#')
for ninterface = [1:length(interfaces)]
  fprintf(fileID, '%i\n', xNumber)
  fprintf(fileID, '%s\n', '#')
  for ix = [1:xNumber]
    fprintf(fileID, '%f %f\n', [x(ix), subInterfaces(ninterface,ix)])
  end
  fprintf(fileID, '%s\n', '#')
end

for nlayer = [1:length(layers)] 
  fprintf(fileID, '%i\n', layers(nlayer))
  fprintf(fileID, '%s\n', '#')
end
fclose(fileID);
