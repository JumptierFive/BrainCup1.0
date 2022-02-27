clc; clear; close;
Clor=[1,0.99999,0.99999];
MaterialN=[0.95/2 0.95/2 0.95/2];
brightenN=0;
Trans=0.2;
faceTrans=0.1;
lineStyle='none';
edgeColor='k';

ImageName1='fMaskCC5.nii';
ImageName21='Mask_ProbResultTCerebullar';
ImageName2=['TractGroupDifference/',ImageName21,'.nii'];

% T1=Image2Triangle(ImageName1,0);
T2=Image2Triangle(ImageName2,0);

% reading template surface
p= mfilename('fullpath');
[filepath,name,ext] = fileparts(p);
cd(filepath);
SurfName='../SurfTemplate/BrainMesh_Ch2withCerebellum.nv';
SurfAll = Surfread(SurfName);


% trisurf(T1.faces,T1.vertices(:,2),T1.vertices(:,1),T1.vertices(:,3),'FaceColor',[0,0,1],'LineStyle',lineStyle,'FaceAlpha',faceTrans,'EdgeColor',edgeColor,'LineWidth',0.1);
% alpha(Trans);
figure('NumberTitle', 'off', 'Name', 'BrainGraphShow');
set(gcf,'units','normalized','position',[0.1,0.1,0.5,0.8]);
trisurf(SurfAll.surfs,SurfAll.vertices(:,1),SurfAll.vertices(:,2),SurfAll.vertices(:,3),'FaceColor',Clor,'LineStyle',lineStyle,'FaceAlpha',faceTrans,'EdgeColor',edgeColor,'LineWidth',0.1);
hold on;
trisurf(T2.faces,T2.vertices(:,2),T2.vertices(:,1),T2.vertices(:,3),'FaceColor',[0.5,0.2,0.2],'LineStyle',lineStyle,'FaceAlpha',0.7,'EdgeColor',edgeColor,'LineWidth',0.1);
lighting flat;
daspect([1 1 1]);
lighting gouraud;
axis([-90,90,-125,91,-71,109]);
axis off;
axis vis3d;
view(90,0);

hlight = camlight('right');
for i=1:1:360
    camorbit(0.5,0);
    camlight(hlight,'right');
    saveas(gcf,['videoPics\',ImageName21,'_',dec2base(i,10,5),'.png']);
end



% reading surface data for vertices location and triangle faces, Leinian Li
% 2020 11 23
function SurfT = Surfread(SurfName)
dlm=dlmread(SurfName);
line=dlm(1,1);
dlm=dlm(2:end,:);
VertAll=dlm(1:line,:);
VertAll(:,1)=VertAll(:,1)-1;
SurfAll=dlm(line+2:end,:);
SurfT.surfs=SurfAll;
SurfT.vertices=VertAll;
end
% image read calculate the vertices and faces, Leinian Li 2020 11 23
function TImage=Image2Triangle(ImageName,Nthreshold)
defualtMat=[
    3,0,0,0;
    0,3,0,0;
    0,0,3,0;
    -127,-75,-70,0];
defualtXline=[
    1,0,0,0;
    0,-1,0,0;
    0,0,1,0;
    0,0,0,0];
% reading image data
stru=spm_vol(ImageName);
rImage=spm_read_vols(stru);
rImage(isnan(rImage))=0;
% rImage=smooth3(rImage,'gaussian',[1,1,1]);

T=isosurface(rImage,Nthreshold);
T.vertices=[T.vertices,ones(length(T.vertices),1)];
Transformation=stru.mat';
tempTrans=Transformation(4,2);
Transformation(4,2)=Transformation(4,1);
Transformation(4,1)=tempTrans;

if Transformation(1,1)<0
    T.vertices=T.vertices*defualtMat*defualtXline;
    % T.vertices(:,2)=T.vertices(:,2)*-1;
else
    T.vertices=T.vertices*Transformation;
end
TImage=T;
end