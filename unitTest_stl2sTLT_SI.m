clc; clear all;close all;

% st5 = 'G[0,1] F[2,3] mu1 Vee alw_[0,10] (x>=3)';
% phi1 = STLformula('0',st5);
% [nodeList,parentList] = STLTreeStucture(phi1);
% tree1 = sTLTObj(nodeList,parentList);
% tree1.draw_sTLT()

case_numb = 2;
% inputs
switch case_numb
    case 0
        st = 'G[0,10] F[2,3] mu1 and G[1,10] F[2,3] mu2';
        predicateList = {'mu1','mu2'}';
        R1.c = [-4;-4]; R1.r = 1.4; R1.obstacle = false;R1.rep = 'circular';
        R2.c = [-2;-2]; R2.r = 1.4; R2.obstacle = false;R2.rep = 'circular';
        
        % Create a containers.Map
        predMap = containers.Map;
        predMap('mu1') = R1;
        predMap('mu2') = R2;
        
    case 1
        st = 'F[0,15] G[2,10] mu1 Vee F[0,15](G[0,10] mu2 Wedge F[5,10] mu3 )';
        predicateList = {'mu1','mu2', 'mu3'}';
        R1.c = [-4;-4]; R1.r = 1; R1.obstacle = false;R1.rep = 'circular';
        R2.c = [4;0];R2.r = 4;R2.obstacle = false; R2.rep = 'circular';
        R3.c = [1;-4];R3.r = 2;R3.obstacle = false;R3.rep = 'circular';

        
        

        % Create a containers.Map
        predMap = containers.Map;
        predMap('mu1') = R1;
        predMap('mu2') = R2;
        predMap('mu3') = R3;

% case 2
    case 2
        st = ['G[0,1] F[2,3] mu1 and F[6,7] G[1,2] mu2' ...
        ' and F[15,16](G[0,4] mu3 and F[1,4] mu1) and G[0,20] (not mu4)' ...
        'and F[15,20] mu5'];
        predicateList = {'mu1', 'mu2', 'mu3', 'mu4','mu5'}';
        R1.c = [-2;2]; R1.r = 1; R1.obstacle = false; R1.rep = 'circular';
        R2.c = [1.5;0.5];R2.r = 1;R2.obstacle = false; R2.rep = 'circular';
        R3.c = [-1;0];R3.r = 1.5;R3.obstacle = false; R3.rep = 'circular';
        R4.c = [0;1.5]; R4.r = 1;R4.obstacle = false; R4.rep = 'circular';
        Square5.c = [-3; -1.5]; Square5.r = 0.5;Square5.obstacle = false;Square5.rep = 'square'; 
        R5.c = Square5.c;R5.r = Square5.r; R5.obstacle =Square5.obstacle; R5.rep = 'circular';
        
        % Create a containers.Map
        predMap = containers.Map;
        predMap('mu1') = R1;
        predMap('mu2') = R2;
        predMap('mu3') = R3;
        predMap('mu4') = R4;
        predMap('mu5') = R5;
end

%% offline computation
phi = STLformula('0',st);
[nodeList,parentList] = STLTreeStucture(phi);
tree = sTLTObj(nodeList,parentList);
tree.draw_sTLT()
tree.BUTran(); % botton up transverse
tree.TDTran(); % top-down transverse
% assigning relevant setNodeObj its region/value function
tree.assignPredicateRegion(predMap);
tree.updateALLRegions();

% Algorithm 3
tree.calStartTimeInterval();
% Algorithm 4 
% tree1.updateStartTimeInterval(nodeIndex,updateTime)
% tree.updateStartTimeInterval(21,10);

% for cbf construction
tree.findAllTemporalFragments();
tree.isAllVeeTopLayer();
tree.findAllBranch();

switch case_numb
    case 1
        save('tree_singleIntegrator_example1.mat','tree')
    case 2
        save('tree_singleIntegrator_example2.mat','tree')
    otherwise
        disp(['case_numb is ' num2str(case_numb)])
end


