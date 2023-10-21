function [BW2] = kubire_delete(BW)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

FIL=zeros(3,3,4);
FIL(:,:,1)=[0,0,0;-1,1,-1;0,0,0];
FIL(:,:,2)=[-1,0,0;0,1,0;0,0,-1];
FIL(:,:,3)=[0,-1,0;0,1,0;0,-1,0];
FIL(:,:,4)=[0,0,-1;0,1,0;-1,0,0];

BW2 = BW;
for k=1:4
    TMP = conv2(single(BW),FIL(:,:,k),'same');
    ind = TMP==1;
    BW2(ind) = 0;
end;

end

