%% make template of all
clc;clear;
stru=spm_vol('volumeMask.nii');

KA=spm_vol('TPM.nii');

aa1=spm_read_vols(KA(1));
aa2=spm_read_vols(KA(2));

aa=aa2+aa1.*0.1;
KA(1).fname='GWM.nii';
spm_write_vol(KA(1),aa);