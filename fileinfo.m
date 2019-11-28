function [fileName,numImages,fr,sz] = fileinfo(indx)

% a function that stores all path and file name information

switch indx
    % 160321_thy1_glassaga05_onlyafteranesthesia
    case 1
        fileName = '160322_thy1_glassaga05_pa4_habi020011';
        numImages = 6758;
        fr = 7.5;
        sz = [451,449];
    case 2
        fileName = '160322_thy1_glassaga05_pa4_fam0012';
        numImages = 3005;
        fr = 7.5;
        sz = [447,447];
    case 3
        fileName = '160322_thy1_glassaga05_pa4_nor0013';
        numImages = 4520;
        fr = 7.5;
        sz = [453,457];
    % 160324_thy1_glassaga03_control_onlyafteranesthesia
    case 4
        fileName = '160325_thy1_glassaga03_pa3_contr_habi020020';
        numImages = 5831;
        fr = 7.5;
        sz = [458,462];
    case 5
        fileName = '160325_thy1_glassaga03_pa3_contr_fam0023';
        numImages = 4577;
        fr = 7.5;
        sz = [464,459];
    case 6
        fileName = '160325_thy1_glassaga03_pa3_contr_nor0024';
        numImages = 4508;
        fr = 7.5;
        sz = [456,460];
    % 160404_mouse_06_no_anesthesia
    case 7
        fileName = '160404_thy1_mouse_06_habi010027';
        numImages = 4635;
        fr = 7.5;
        sz = [459,472];
    case 8
        fileName = '160406_thy1_mouse_06_fam0030';
        numImages = 4513;
        fr = 7.5;
        sz = [456,462];
    case 9
        fileName = '160406_thy1_mouse_06_nor0031';
        numImages = 4607;
        fr = 7.5;
        sz = [454,466];
    case 10
        fileName = '160412_thy1_mouse_06_habi_again0039';
        numImages = 4761;
        fr = 7.5;
        sz = [463,467];
    case 11
        fileName = '160412_thy1_mouse_06_fam_again0040';
        numImages = 4504;
        fr = 7.5;
        sz = [456,458];
    case 12
        fileName = '160412_thy1_mouse_06_nor_again0044';
        numImages = 4558;
        fr = 7.5;
        sz = [457,452];
    % 160404_mouse_07_no_anesthesia
    case 13
        fileName = '160404_thy1_mouse_07_habi010028';
        numImages = 4570;
        fr = 7.5;
        sz = [458,461];
    case 14
        fileName = '160406_thy1_mouse_07_fam0029';
        numImages = 4570;
        fr = 7.5;
        sz = [460,471];
    case 15
        fileName = '160406_thy1_mouse_07_nor0032';
        numImages = 4510;
        fr = 7.5;
        sz = [457,467];
    case 16
        fileName = '160412_thy1_mouse_07_habi_again0041';
        numImages = 5636;
        fr = 7.5;
        sz = [460,468];
    case 17
        fileName = '160412_thy1_mouse_07_fam_again0042';
        numImages = 4629;
        fr = 7.5;
        sz = [463,471];
    case 18
        fileName = '160412_thy1_mouse_07_nor_again0043';
        numImages = 4558;
        fr = 7.5;
        sz = [464,462];
    % 160408_mouse_08_anesthesia
    case 19
        fileName = '160408_thy1_mouse_08_hab010033';
        numImages = 4541;
        fr = 7.5;
        sz = [459,467];
    case 20
        fileName = '160410_thy1_mouse_08_fam0035';
        numImages = 4511;
        fr = 7.5;
        sz = [461,467];
    case 21
        fileName = '160410_thy1_mouse_08_nor0037';
        numImages = 4541;
        fr = 7.5;
        sz = [462,471];
    case 22
        fileName = '160414_thy1_mouse_08_pa3_habd0045';
        numImages = 4539;
        fr = 7.5;
        sz = [459,479];
    case 23
        fileName = '160414_thy1_mouse_08_pa3_fam0047';
        numImages = 4528;
        fr = 7.5;
        sz = [463,470];
    case 24
        fileName = '160414_thy1_mouse_08_pa3_nor0049';
        numImages = 4567;
        fr = 7.5;
        sz = [466,484];
    % 160408_mouse_09_anesthesia
    case 25
        fileName = '160408_thy1_mouse_09_hab010034';
        numImages = 5111;
        fr = 7.5;
        sz = [465,476];
    case 26
        fileName = '160410_thy1_mouse_09_fam0036';
        numImages = 4526;
        fr = 7.5;
        sz = [469,480];
    case 27
        fileName = '160410_thy1_mouse_09_nor0038';
        numImages = 4425;
        fr = 7.5;
        sz = [470,488];
    case 28
        fileName = '160414_thy1_mouse_09_pa3_habd0046';
        numImages = 4752;
        fr = 7.5;
        sz = [471,491];
    case 29
        fileName = '160414_thy1_mouse_09_pa3_fam0048';
        numImages = 4529;
        fr = 7.5;
        sz = [471,485];
    case 30
        fileName = '160414_thy1_mouse_09_pa3_nor0050';
        numImages = 4582;
        fr = 7.5;
        sz = [472,483];
    % 160712_mouse_29_no_anesthesia
    case 31
        fileName = '160712_thy1_16months_old_mouse_29f_habi_d10171';
        numImages = 4511;
        fr = 7.5;
        sz = [469,479];
    case 32
        fileName = '160713_thy1_16months_old_mouse_29f_fam0175';
        numImages = 11375;
        fr = 7.5;
        sz = [471,491];
    case 33
        fileName = '160713_thy1_16months_old_mouse_29f_nor0179';
        numImages = 4499;
        fr = 7.5;
        sz = [473,483];
    case 34
        fileName = '160713_thy1_16months_old_mouse_29f_habiagain0183';
        numImages = 4500;
        fr = 7.5;
        sz = [472,486];
    case 35
        fileName = '160713_thy1_16months_old_mouse_29f_famagain0184';
        numImages = 4474;
        fr = 7.5;
        sz = [469,492];
    case 36
        fileName = '160713_thy1_16months_old_mouse_29f_noragain0192';
        numImages = 4499;
        fr = 7.5;
        sz = [475,486];
    % 160712_mouse_30 (anesthesia)
    case 37
        fileName = '160712_thy1_16months_old_mouse_30_habi_d10172';
        numImages = 4521;
        fr = 7.5;
        sz = [474,490];
    case 38
        fileName = '160713_thy1_16months_old_mouse_30_fam0176';
        numImages = 4500;
        fr = 7.5;
        sz = [475,485];
    case 39
        fileName = '160713_thy1_16months_old_mouse_30_nor0180';
        numImages = 4500;
        fr = 7.5;
        sz = [470,482];
    case 40
        fileName = '160713_thy1_16months_old_mouse_30_habiagain0185';
        numImages = 4499;
        fr = 7.5;
        sz = [473,489];
    case 41
        fileName = '160713_thy1_16months_old_mouse_30_famagain0186';
        numImages = 4500;
        fr = 7.5;
        sz = [472,492];
    case 42
        fileName = '160713_thy1_16months_old_mouse_30_noragain0193';
        numImages = 4500;
        fr = 7.5;
        sz = [478,491];
    % 160712_mouse_31_no_anesthesia
    case 43
        fileName = '160712_nkx_14months_old_mouse_31br_habi_d10173';
        numImages = 5389;
        fr = 7.5;
        sz = [469,494];
    case 44
        fileName = '160713_nkx_14months_old_mouse_31br_fam0177';
        numImages = 4500;
        fr = 7.5;
        sz = [476,487];
    case 45
        fileName = '160713_nkx_14months_old_mouse_31br_nor0181';
        numImages = 4500;
        fr = 7.5;
        sz = [476,485];
    case 46
        fileName = '160713_nkx_14months_old_mouse_31br_habiagain0187';
        numImages = 4500;
        fr = 7.5;
        sz = [478,486];
    case 47
        fileName = '160713_nkx_14months_old_mouse_31br_famiagain0188';
        numImages = 4499;
        fr = 7.5;
        sz = [479,490];
    case 48
        fileName = '160713_nkx_14months_old_mouse_31br_noragain0194';
        numImages = 4499;
        fr = 7.5;
        sz = [476,496];
    % ---------------------- ketamine mouse ---------------------- %
    % 160729_mouse_36_Ket_10_no_imaging
    case 101
        fileName = '160726_thy1_4months_old_mouse_36_habi10199';
        numImages = 4500;
        fr = 7.5;
        sz = [477,491];
    case 102
        fileName = '160727_thy1_4months_old_mouse_36_fam10203';
        numImages = 4221;
        fr = 7.5;
        sz = [479,491];
    case 103
        fileName = '160727_thy1_4months_old_mouse_36_nor10209';
        numImages = 4499;
        fr = 7.5;
        sz = [478,487];
    case 104
        fileName = '160730_thy1_4months_old_mouse_36_habiagain0210';
        numImages = 4396;
        fr = 7.5;
        sz = [475,487];
    case 105
        fileName = '160730_thy1_4months_old_mouse_36_famagain0211';
        numImages = 4499;
        fr = 7.5;
        sz = [475,481];
    case 106
        fileName = '160730_thy1_4months_old_mouse_36_nor2again0215';
        numImages = 4499;
        fr = 7.5;
        sz = [466,476];
    % 160803_mouse_39_Ket_no_imaging
    case 107
        fileName = '160802_thy1_4months_old_mouse_39_habi0218';
        numImages = 4499;
        fr = 7.5;
        sz = [473,486];
    case 108
        fileName = '160803_thy1_4months_old_mouse_39_fam0223';
        numImages = 4499;
        fr = 7.5;
        sz = [463,487];
    case 109
        fileName = '160803_thy1_4months_old_mouse_39_nor0225';
        numImages = 4499;
        fr = 7.5;
        sz = [475,481];
    case 110
        fileName = '160805_thy1_4months_old_mouse_39_habiagain0229';
        numImages = 4499;
        fr = 7.5;
        sz = [471,484];
    case 111
        fileName = '160805_thy1_4months_old_mouse_39_famagain0230';
        numImages = 4499;
        fr = 7.5;
        sz = [469,486];
    case 112
        fileName = '160805_thy1_4months_old_mouse_39_noragain0234';
        numImages = 4499;
        fr = 7.5;
        sz = [474,492];
    % 160814_mouse_41_Ket
    case 113
        fileName = '160811_thy1_4months_old_mouse_41_habi0235';
        numImages = 4500;
        fr = 7.5;
        sz = [470,482];
    case 114
        fileName = '160814_thy1_4months_old_mouse_41_fami0240';
        numImages = 4499;
        fr = 7.5;
        sz = [475,483];
    case 115
        fileName = '160814_thy1_4months_old_mouse_41_nor0244';
        numImages = 4499;
        fr = 7.5;
        sz = [472,480];
    case 116
        fileName = '160816_thy1_4months_old_mouse_41_habiagain0248';
        numImages = 4500;
        fr = 7.5;
        sz = [472,469];
    case 117
        fileName = '160816_thy1_4months_old_mouse_41_famagain0249';
        numImages = 4499;
        fr = 7.5;
        sz = [473,477];
    % 160814_mouse_42_Ket
    case 118
        fileName = '160811_thy1_4months_old_mouse_42_habi0236';
        numImages = 4499;
        fr = 7.5;
        sz = [471,491];
    case 119
        fileName = '160814_thy1_4months_old_mouse_42_fam0241';
        numImages = 4499;
        fr = 7.5;
        sz = [473,488];
    case 120
        fileName = '160814_thy1_4months_old_mouse_42_nor0245';
        numImages = 4499;
        fr = 7.5;
        sz = [474,485];
    case 121
        fileName = '160816_thy1_4months_old_mouse_42_habiagain0254';
        numImages = 4499;
        fr = 7.5;
        sz = [474,487];
    case 122
        fileName = '160816_thy1_4months_old_mouse_42_famagain0255';
        numImages = 4499;
        fr = 7.5;
        sz = [474,479];
    % 160814_mouse_43_Ket
    case 123
        fileName = '160811_thy1_4months_old_mouse_43_habi0237';
        numImages = 5167;
        fr = 7.5;
        sz = [479,488];
    case 124
        fileName = '160814_thy1_4months_old_mouse_43_fam0242';
        numImages = 4499;
        fr = 7.5;
        sz = [463,476];
    case 125
        fileName = '160814_thy1_4months_old_mouse_43_nor0246';
        numImages = 4499;
        fr = 7.5;
        sz = [477,487];
    case 126
        fileName = '160816_thy1_4months_old_mouse_43_habiagain0252';
        numImages = 4499;
        fr = 7.5;
        sz = [474,485];
    case 127
        fileName = '160816_thy1_4months_old_mouse_43_famagain0253';
        numImages = 4499;
        fr = 7.5;
        sz = [473,482];
    % 160814_mouse_44_Ket
    case 128
        fileName = '160811_thy1_4months_old_mouse_44_habi0239';
        numImages = 4499;
        fr = 7.5;
        sz = [471,482];
    case 129
        fileName = '160814_thy1_4months_old_mouse_44_fam0243';
        numImages = 4499;
        fr = 7.5;
        sz = [471,484];
    case 130
        fileName = '160814_thy1_4months_old_mouse_44_nor0247';
        numImages = 4499;
        fr = 7.5;
        sz = [473,471];
    case 131
        fileName = '160816_thy1_4months_old_mouse_44_habiagain0250';
        numImages = 4500;
        fr = 7.5;
        sz = [470,473];
    case 132
        fileName = '160816_thy1_4months_old_mouse_44_famagain0251';
        numImages = 4500;
        fr = 7.5;
        sz = [468,482];
    case 133
        fileName = '160816_thy1_4months_old_mouse44_noragain0258';
        numImages = 4499;
        fr = 7.5;
        sz = [473,480];
    case 134
        fileName = '160816_thy1_4months_old_mouse44_noragain0259';
        numImages = 4499;
        fr = 7.5;
        sz = [471,479];
    
end
    


end
