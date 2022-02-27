clc; clear; close;
MaterialN=[0.95/2 0.95/2 0.95/2];
Mb=spm_read_vols(spm_vol('GWM.nii'));
Mb = squeeze(Mb);
limitsK=[1 25 1 65 1 50];
hf=figure(1);
hclight = camlight('headlight');
view(-55,0);
%[133 140 85 140 1 2]
%[78 140 57 140 1 2]
cutFigure = cutBrain(Mb,[1 2 45 140 1 2],0.06,0.06,'interp','none',[0.9 0.9 0.9],'none');
gray1=gray;
gray1=gray1([1,40,41,59,60,61],:);
colormap(gray1)
axis([1 145 1 121 1 121]);
axis vis3d;
axis off;
daspect([1 1 1]);
material(MaterialN);
lighting gouraud;

for ki=1:1:1000000
    if ishandle(hf)
        camlight(hclight,'left');
        pause(0.01);
    else
        break;
    end
end


function [CutF] = cutBrain(K,limitsN,surfaceThresh,capsThresh,capsFaceColor,capsEdgeColor,surfaceColor,surfaceEdgeColor)

% plot figure of cut brains, leinian li 2020 11 27
% inputs

cutFaceColor=gray;
cutFaceColor(1:10,:)=[];


limits = [NaN NaN NaN NaN NaN NaN];
limits(1:2)=limitsN(1:2);
[x, y, z, D] = subvolume(K,limits);           % extract a subset of the volume data
[fo,vo] = isosurface(x,y,z,D,surfaceThresh);               % isosurface for the outside of the volume
[fe,ve,ce] = isocaps(x,y,z,D,capsThresh);               % isocaps for the end caps of the volume

cutN=1;
if ~isempty(fo)
    CutF{cutN} = patch('Faces', fo, 'Vertices', vo);       % draw the outside of the volume
    CutF{cutN}.FaceColor = surfaceColor;
    CutF{cutN}.EdgeColor = surfaceEdgeColor;
    cutN=cutN+1;
end

hold on;


if ~isempty(fe)
    [fe,ve,ce] = capsLimitation(fe,ve,ce,limitsN);
    CutF{cutN} = patch('Faces', fe, 'Vertices', ve, ...    % draw the end caps of the volume
        'FaceVertexCData', ce );
    
    CutF{cutN}.FaceColor = capsFaceColor;
    CutF{cutN}.EdgeColor = capsEdgeColor;
    cutN=cutN+1;
end
hold on;
limits = [NaN NaN NaN NaN NaN NaN];
limits(3:4)=limitsN(3:4);

[x, y, z, D] = subvolume(K, limits);           % extract a subset of the volume data
[fo,vo] = isosurface(x,y,z,D,surfaceThresh);               % isosurface for the outside of the volume
[fe,ve,ce] = isocaps(x,y,z,D,capsThresh);               % isocaps for the end caps of the volume



if ~isempty(fo)
    CutF{cutN} = patch('Faces', fo, 'Vertices', vo);       % draw the outside of the volume
    CutF{cutN}.FaceColor = surfaceColor;
    CutF{cutN}.EdgeColor = surfaceEdgeColor;
    cutN=cutN+1;
end

hold on;



if ~isempty(fe)
    [fe,ve,ce] = capsLimitation(fe,ve,ce,limitsN);
    CutF{cutN} = patch('Faces', fe, 'Vertices', ve, ...    % draw the end caps of the volume
        'FaceVertexCData', ce);
    CutF{cutN}.FaceColor = capsFaceColor;
    CutF{cutN}.EdgeColor = capsEdgeColor;
    cutN=cutN+1;
end


hold on;
limits = [NaN NaN NaN NaN NaN NaN];
limits(5:6)=limitsN(5:6);
[x, y, z, D] = subvolume(K, limits);           % extract a subset of the volume data
[fo,vo] = isosurface(x,y,z,D,surfaceThresh);               % isosurface for the outside of the volume
[fe,ve,ce] = isocaps(x,y,z,D,capsThresh);     % isocaps for the end caps of the volume

if ~isempty(fo)
    CutF{cutN} = patch('Faces', fo, 'Vertices', vo);       % draw the outside of the volume
    CutF{cutN}.FaceColor = surfaceColor;
    CutF{cutN}.EdgeColor = surfaceEdgeColor;
    cutN=cutN+1;
end

hold on;

if ~isempty(fe)
    [fe,ve,ce] = capsLimitation(fe,ve,ce,limitsN);
    CutF{cutN} = patch('Faces', fe, 'Vertices', ve, ...    % draw the end caps of the volume
        'FaceVertexCData', ce);
    CutF{cutN}.FaceColor = capsFaceColor;
    CutF{cutN}.EdgeColor = capsEdgeColor;
    cutN=cutN+1;
end
end




function [faceE,verticeE,ceightE] = capsLimitation(fE,vE,cE,limitation)
% delete useless cap face part, Leinian Li 2020 11 25
xco1=find(vE(:,1)>=limitation(2));
xco2=find(vE(:,1)<=limitation(1));
yco1=find(vE(:,2)>=limitation(4));
yco2=find(vE(:,2)<=limitation(3));
zco1=find(vE(:,3)>=limitation(6));
zco2=find(vE(:,3)<=limitation(5));
% remainCo=sort(unique([xco1;xco2;yco1;yco2;zco1;zco2]'))
remainCo=sort(intersect(intersect(union(xco1,xco2),union(yco1,yco2)),union(zco1,zco2)));
verticeE=vE(remainCo,:);
ceightE=cE(remainCo,:);
fnaNum=1:1:numel(vE(:,1));
fnaNum=fnaNum(remainCo);

deleF=[];
for i=1:1:numel(fE(:,1))
    if sum(ismember(fE(i,:),remainCo))==3
        xNew=find(fnaNum==fE(i,1));fE(i,1)=xNew;
        yNew=find(fnaNum==fE(i,2));fE(i,2)=yNew;
        zNew=find(fnaNum==fE(i,3));fE(i,3)=zNew;
    else
        deleF=[deleF,i];
    end
end

faceE=fE;
faceE(deleF,:)=[];
end