clc
warning('off','all')
%Read data for the FIS
filename = ('Test_Data.xls');
TestData=xlsread(filename);

%%----------------------------------------------
%%          System1 Device Direction
%%----------------------------------------------

a=newfis('Object_Direction');

a=addvar(a,'input','Sensor1',[0 1]);

a = addmf(a,'input',1,'No_Detected','trapmf',[-1 0 0.25 0.5]);
a = addmf(a,'input',1,'Partially_Detected','trimf', [0.4 0.5 0.6]);
a = addmf(a,'input',1,'Detection','trapmf',[0.5 0.75 1 1.1]);


a=addvar(a,'input','Sensor2',[0 1]);

a = addmf(a,'input',2,'No_Detected','trapmf',[-1 0 0.25 0.5]);
a = addmf(a,'input',2,'Partially_Detected','trimf', [0.4 0.5 0.6]);
a = addmf(a,'input',2,'Detection','trapmf',[0.5 0.75 1 1.1]);

a=addvar(a,'input','Sensor3',[0 1]);

a = addmf(a,'input',3,'No_Detected','trapmf',[-1 0 0.25 0.5]);
a = addmf(a,'input',3,'Partially_Detected','trimf', [0.4 0.5 0.6]);
a = addmf(a,'input',3,'Detection','trapmf',[0.5 0.75 1 1.1]);

a=addvar(a,'input','Sensor4',[0 1]);

a = addmf(a,'input',4,'No_Detected','trapmf',[-1 0 0.25 0.5]);
a = addmf(a,'input',4,'Partially_Detected','trimf', [0.4 0.5 0.6]);
a = addmf(a,'input',4,'Detection','trapmf',[0.5 0.75 1 1.1]);

a=addvar(a,'input','Sensor5',[0 1]);

a = addmf(a,'input',5,'No_Detected','trapmf',[-1 0 0.25 0.5]);
a = addmf(a,'input',5,'Partially_Detected','trimf', [0.4 0.5 0.6]);
a = addmf(a,'input',5,'Detection','trapmf',[0.5 0.75 1 1.1]);


a=addvar(a,'output','Object_Direction',[0 180]);

a = addmf(a,'output', 1, 'Far_Left', 'trapmf', [-1 0 20 40]);
a = addmf(a,'output', 1, 'Left', 'trimf', [35 50 65]);
a = addmf(a,'output',1, 'Middle', 'trapmf', [60 75 105 120]);
a = addmf(a,'output',1, 'Right', 'trimf', [115 130 145]);
a = addmf(a,'output',1, 'Far_Right','trapmf', [140 160 180 181]);

%%Rules
%%Far_Left
rule1 = [3 1 1 1 1 1 0.8 1];
rule2 = [3 2 1 1 1 1 0.8 1];
rule3 = [3 2 2 1 1 1 0.8 1];
rule4 = [3 3 2 1 1 1 0.8 1];

%%Left
rule5 = [3 3 1 1 1 2 0.8 1];
rule6 = [2 3 1 1 1 2 0.8 1];
rule7 = [2 3 2 1 1 2 0.8 1];
rule8 = [1 3 2 1 1 2 0.8 1];
rule8a = [1 3 1 1 1 2 0.8 1];
rule8b = [1 3 3 1 1 2 0.8 1];

%%Middle
rule9 = [1 1 3 1 1 3 0.8 1];
rule10 = [1 2 3 1 1 3 0.8 1];
rule11 = [1 1 3 2 1 3 0.8 1];
rule12= [1 2 3 2 1 3 0.8 1];
rule13= [2 2 3 2 1 3 0.8 1];
rule14= [2 2 3 2 2 3 0.8 1];
rule15= [1 2 3 2 2 3 0.8 1];
rule16= [2 3 3 3 2 3 0.8 1];
rule17= [1 3 3 3 2 3 0.8 1];
rule18= [1 3 3 3 1 3 0.8 1];
rule19= [2 3 3 3 1 3 0.8 1];

%%Right
rule20= [1 1 1 3 1 4 0.8 1];
rule21= [1 1 1 3 2 4 0.8 1];
rule22= [1 1 2 3 2 4 0.8 1];
rule23= [1 1 2 3 1 4 0.8 1];

%%Far_Right
rule24= [1 1 1 1 3 5 0.8 1];
rule25= [1 1 1 2 3 5 0.8 1];
rule26= [1 1 2 2 3 5 0.8 1];
rule27= [1 1 1 3 3 5 0.8 1];

%rule base
ruleListA= [rule1; rule2; rule3; rule4; rule5; rule6; rule7;
    rule8; rule9; rule10; rule11; rule12; rule13; rule14;
    rule15; rule16; rule17; rule18; rule19; rule20; rule21;
    rule22; rule23; rule24; rule25; rule26; rule27];

%Add The rules to the system
a = addRule(a,ruleListA);

%Print rules to the workspace
rule = showrule(a)

%defuzzification methods
a.defuzzMethod = 'centroid';
%a.defuzzMethod = 'bisector';
%a.defuzzMethod = 'mom';
%a.defuzzMethod = 'som';
%a.defuzzMethod = 'lom';


for i=1:size(TestData,1)
    evaldata = evalfis(a, [TestData(i,1), TestData(i, 2), TestData(i,3), TestData(i,4), TestData(i,5)]);
    fprintf('%d) In(1): %.2f, In(2) %.2f, In(3) %.2f, In(4) %.2f, In(5) %.2f  => Out: %.2f \n\n',i, ...
        TestData(i, 1),TestData(i, 2),TestData(i,3),TestData(i,4),TestData(i,5),  evaldata);
    xlswrite('output.xls', evaldata, 1, sprintf('A%d',i+1));

end

%%--------------------------------
%%      System2 Obstacle Distance
%%--------------------------------

b=newfis('ObstacleDanger');

b=addvar(b,'input','ObstacleDistance',[0 100]);
b=addmf(b,'input',1,'Very_Close','trapmf',[-1 0 10 20]);
b=addmf(b,'input',1,'Close','trimf',[15 25 35]);
b=addmf(b,'input',1,'Middle','trapmf',[30 40 60 70]);
b=addmf(b,'input',1,'Far','trimf',[65 75 85]);
b=addmf(b,'input',1,'Very_Far','trapmf', [80 90 100 101]);

b=addvar(b,'input','ObstacleSize', [0 100]);
b=addmf(b,'input',2,'Very_Small','trapmf',[-1 0 10 20]);
b=addmf(b,'input',2,'Small','trapmf',[15 25 35 45]);
b=addmf(b,'input',2,'Medium','trapmf',[35 45 55 65]);
b=addmf(b,'input',2,'Large','trapmf',[55 65 75 85]);
b=addmf(b,'input',2,'Very_Large','trapmf',[80 90 100 101]);

b=addvar(b,'output','ObstacleUrgency',[0 100]);
b=addmf(b,'output',1,'Urgent_Action','trapmf',[-1 0 10 20]);
b=addmf(b,'output',1,'Quick_Action','trapmf',[15 25 35 45]);
b=addmf(b,'output',1,'Average_Action','trapmf',[30 40 60 70]);
b=addmf(b,'output',1,'Slight_Action','trapmf', [55 65 75 85]);
b=addmf(b,'output',1,'No_Action','trapmf',[80 90 100 101]);

%%Rules
%%Urgent Action
rule28=[1 1 1 0.9 1];
rule29=[1 2 1 0.9 1];
rule30=[1 3 1 0.9 1];
rule31=[1 4 1 0.9 1];
rule32=[1 5 1 0.9 1];
rule33=[2 5 1 0.9 1];
rule34=[3 5 1 0.9 1];
rule35=[4 5 1 0.9 1];

%%Quick Action
rule36=[2 1 2 0.9 1];
rule37=[2 2 2 0.9 1];
rule38=[2 3 2 0.9 1];
rule39=[2 4 2 0.9 1];
rule40=[2 5 2 0.9 1];
rule41=[5 5 2 0.9 1];

%%Average_Action
rule42=[3 1 3 0.9 1];
rule43=[3 2 3 0.9 1];
rule44=[3 3 3 0.9 1];
rule45=[3 4 3 0.9 1];
rule46=[3 5 3 0.9 1];
rule47=[5 5 3 0.9 1];
rule48=[4 5 3 0.9 1];

%%Slight_Action
rule49=[4 1 4 0.9 1];
rule50=[4 2 4 0.9 1];
rule51=[4 3 4 0.9 1];
rule52=[4 4 4 0.9 1];

%%No_Action
rule53=[5 1 5 0.9 1];
rule54=[5 2 5 0.9 1];
rule55=[5 3 5 0.9 1];
rule56=[5 4 5 0.9 1];

%%compile the rule list
ruleListB=[rule28; rule29; rule30; rule31; rule32; rule33; rule34; rule35; rule36; rule37;
    rule38; rule39; rule40; rule41; rule42; rule43; rule44;
    rule45; rule46; rule47; rule48; rule49; rule50; rule51;
    rule52; rule53; rule54; rule55; rule56];

%%Add the rule list
b = addrule(b,ruleListB);

rules=showrule(b)

%defuzzification methods
b.defuzzMethod = 'centroid';
%b.defuzzMethod = 'bisector';
%b.defuzzMethod = 'mom';
%b.defuzzMethod = 'som';
%b.defuzzMethod = 'lom';

for i=1:size(TestData,1)
        evalDanger = evalfis(b, [TestData(i, 7), TestData(i, 8)]);
        fprintf('%d) In(1): %.2f, In(2) %.2f,  => Out: %.2f \n\n',i,TestData(i, 7),TestData(i, 8), evalDanger);  
        xlswrite('output.xls', evalDanger, 1, sprintf('C%d',i+1));
end

%%--------------------------
%%      Third System (Device speed and direction)
%%--------------------------
c=newfis('DeviceHeading');

c=addvar(c,'input','DeviceSpeed',[0 70]);
c=addmf(c,'input',1,'Very_Slow','trimf',[-10 0 10]);
c=addmf(c,'input',1,'Slow','trimf',[7.5 15 22.5]);
c=addmf(c,'input',1,'Average_Speed','trapmf',[20 25 35 40]);
c=addmf(c,'input',1,'Fast','trimf',[35 45 55]);
c=addmf(c,'input',1,'Very_Fast','trapmf',[50 60 70 100]);

c=addvar(c,'input','DeviceDirection',[0 180]);
c=addmf(c,'input',2,'Left','trapmf',[-1 0 30 60]);
c=addmf(c,'input',2,'Forward','trapmf',[40 60 120 140]);
c=addmf(c,'input',2,'Right','trapmf',[120 145 180 200]);


c=addvar(c,'output','ObjectHeading',[0 100]);
c=addmf(c,'output',1,'Very_Hard_Left','trimf',[-1 0 15]);
c=addmf(c,'output',1,'Hard_Left','trimf',[10 20 30]);
c=addmf(c,'output',1,'Average_Left','trimf',[25 35 45]);
c=addmf(c,'output',1,'Forward','trimf',[40 50 60]);
c=addmf(c,'output',1,'Average_Right','trimf',[55 65 75]);
c=addmf(c,'output',1,'Hard_Right','trimf',[70 80 90]);
c=addmf(c,'output',1,'Very_Hard_Right','trimf',[85 100 101]);

%%Declare Rules
%Very_Hard_Left
rule57=[5 1 1 0.3 1];

%Hard_Left
rule58=[4 1 2 0.3 1];

%Average_Left
rule59=[3 1 3 0.3 1];
rule60=[2 1 3 0.3 1];
rule61=[1 1 3 0.3 1];

%Forward
rule62=[1 2 4 0.3 1];
rule63=[2 2 4 0.3 1];
rule64=[3 2 4 0.3 1];
rule65=[4 2 4 0.3 1];
rule66=[5 2 4 0.3 1];

%Average_Right
rule67=[3 3 5 0.3 1];
rule68=[2 3 5 0.3 1];
rule69=[1 3 5 0.3 1];

%Hard_Right
rule70=[4 3 6 0.3 1];

%Very_Hard_Right
rule71=[5 3 7 0.3 1];

%%Compile Rule list
ruleListC=[rule57;rule58;rule59;
    rule60;rule61;rule62;rule63;rule64;rule65;
    rule66;rule67;rule68;rule69; rule70; rule71];

%Add the rule list
c = addrule(c,ruleListC);

rules=showrule(c)

%defuzzification methods
c.defuzzMethod = 'centroid';
%c.defuzzMethod = 'bisector';
%c.defuzzMethod = 'mom';
%c.defuzzMethod = 'som';
%c.defuzzMethod = 'lom';

for i=1:size(TestData,1)
        evalDanger = evalfis(c, [TestData(i, 10), TestData(i, 11)]);
        fprintf('%d) In(1): %.2f, In(2) %.2f,  => Out: %.2f \n\n',i,TestData(i, 10),TestData(i, 11), evalDanger);  
        xlswrite('output.xls', evalDanger, 1, sprintf('E%d',i+1));
end

%%-----------------------------------
%%      System 4 (Interference needed)
%%-----------------------------------

outputFileName = ('output.xls');
TestData2=xlsread(outputFileName);

d=newfis('InterferenceNeeded');

d=addvar(d,'input','ObjectDirection',[0 180]);
d = addmf(d,'input', 1, 'Far_Left', 'trapmf', [-1 0 20 40]);
d = addmf(d,'input', 1, 'Left', 'trimf', [35 50 65]);
d = addmf(d,'input',1, 'Middle', 'trapmf', [60 75 105 120]);
d = addmf(d,'input',1, 'Right', 'trimf', [115 130 145]);
d = addmf(d,'input',1, 'Far_Right','trapmf', [140 160 180 181]);

d=addvar(d,'input','DeviceHeading',[0 100]);
d=addmf(d,'input',2,'Very_Hard_Left','trimf',[-1 0 15]);
d=addmf(d,'input',2,'Hard_Left','trimf',[10 20 30]);
d=addmf(d,'input',2,'Average_Left','trimf',[25 35 45]);
d=addmf(d,'input',2,'Forward','trimf',[40 50 60]);
d=addmf(d,'input',2,'Average_Right','trimf',[55 65 75]);
d=addmf(d,'input',2,'Hard_Right','trimf',[70 80 90]);
d=addmf(d,'input',2,'Very_Hard_Right','trimf',[85 100 101]);

d=addvar(d,'output','InterferenceNeeded',[0 100]);
d=addmf(d,'output',1,'No','gaussmf',[30 0]);
d=addmf(d,'output',1,'Potential','trimf',[40 50 60]);
d=addmf(d,'output',1,'Yes','gaussmf',[30 100]);

%%Declare Rules
%No
rule72=[1 7 1 1 1];
rule73=[1 6 1 1 1];
rule74=[1 5 1 1 1];
rule75=[5 1 1 1 1];
rule76=[5 2 1 1 1];
rule77=[5 3 1 1 1];
rule77a=[4 3 1 1 1];
rule77b=[3 1 1 1 1];
rule77c=[2 5 1 1 1];
rule77d=[2 6 1 1 1];

%Potential
rule78=[1 3 2 1 1];
rule79=[1 4 2 1 1];
rule80=[2 4 2 1 1];
rule81=[5 4 2 1 1];
rule82=[5 5 2 1 1];
rule83=[4 4 2 1 1];
rule83a=[3 3 2 1 1];
rule83b=[3 5 2 1 1];
rule83c=[5 3 2 1 1];
rule83d=[3 6 2 1 1];
rule83e=[3 7 2 1 1];

%Yes
rule84=[1 1 3 1 1];
rule85=[1 2 3 1 1];
rule86=[2 1 3 1 1];
rule87=[2 2 3 1 1];
rule88=[5 7 3 1 1];
rule89=[5 6 3 1 1];
rule90=[4 6 3 1 1];
rule91=[4 7 3 1 1];
rule92=[2 3 3 1 1];
rule93=[4 5 3 1 1];
rule93a=[3 4 3 1 1];

%%Compile rule list
ruleListD=[rule72;rule73;
    rule74;rule75;rule76;rule77a;rule77b;
    rule77c;rule77d;rule78;rule79;rule80;rule81;
    rule82;rule83;rule83a;rule83b;rule83c;rule83d;
    rule83e;rule84;rule85;rule86;rule87;rule88;
    rule89;rule90;rule91;rule92;rule93;rule93a];

d= addrule(d,ruleListD);

rules = showrule(d)

%defuzzification methods
d.defuzzMethod = 'centroid';
%d.defuzzMethod = 'bisector';
%d.defuzzMethod = 'mom';
%d.defuzzMethod = 'som';
%d.defuzzMethod = 'lom';

for i=1:size(TestData2,1)
        evalDanger = evalfis(d,[TestData2(i, 1), TestData2(i, 5)]);
        fprintf('%d) In(1): %.2f, In(2) %.2f,  => Out: %.2f \n\n',i,TestData2(i, 1),TestData2(i, 5), evalDanger);  
        xlswrite('output.xls', evalDanger, 1, sprintf('G%d',i+1));
end

%%--------------------
%% System 5 (Change of speed)
%%--------------------

e=newfis('ChangeOfSpeed');

e=addvar(e,'input','ObjectDirection',[0 180]);
e = addmf(e,'input', 1, 'Far_Left', 'trapmf', [-1 0 20 40]);
e = addmf(e,'input', 1, 'Left', 'trimf', [35 50 65]);
e = addmf(e,'input',1, 'Middle', 'trapmf', [60 75 105 120]);
e = addmf(e,'input',1, 'Right', 'trimf', [115 130 145]);
e = addmf(e,'input',1, 'Far_Right','trapmf', [140 160 180 181]);

e=addvar(e,'input','ObstacleUrgency',[0 100]);
e=addmf(e,'input',2,'Urgent_Action','trapmf',[-1 0 10 20]);
e=addmf(e,'input',2,'Quick_Action','trapmf',[15 25 35 45]);
e=addmf(e,'input',2,'Average_Action','trapmf',[30 40 60 70]);
e=addmf(e,'input',2,'Slight_Action','trapmf', [55 65 75 85]);
e=addmf(e,'input',2,'No_Action','trapmf',[80 90 100 101]);

e=addvar(e,'input','DeviceSpeed',[0 70]);
e=addmf(e,'input',3,'Very_Slow','trimf',[-10 0 10]);
e=addmf(e,'input',3,'Slow','trimf',[7.5 15 22.5]);
e=addmf(e,'input',3,'Average_Speed','trapmf',[20 25 35 40]);
e=addmf(e,'input',3,'Fast','trimf',[35 45 55]);
e=addmf(e,'input',3,'Very_Fast','trapmf',[50 60 70 100]);

e=addvar(e,'output','ChangeOfSpeed',[0 100]);
e=addmf(e,'output',1,'Brake_Hard','trapmf',[-10 -1 10 20]);
e=addmf(e,'output',1,'Brake','trimf',[15 25 35]);
e=addmf(e,'output',1,'Brake_Softly','trimf',[30 40 50]);
e=addmf(e,'output',1,'Maintain','trimf',[40 50 60]);
e=addmf(e,'output',1,'Accelerate_Softly','trimf',[50 60 70]);
e=addmf(e,'output',1,'Accelerate','trimf',[65 75 85]);
e=addmf(e,'output',1,'Accelerate_Hard','trimf',[80 90 100 110]);

% Create rules
%Brake_Hard
rule94=[3 1 5 1 1 1];
rule95=[3 1 4 1 1 1];
rule96=[3 2 5 1 1 1];
rule96a=[3 4 4 1 1 1];
rule96b=[3 1 3 1 1 1];
rule96c=[3 1 2 1 1 1];
rule96d=[3 3 5 1 1 1];

%Brake
rule97=[2 2 4 2 1 1];
rule98=[4 2 4 2 1 1];
rule99=[2 2 5 2 1 1];
rule100=[4 2 5 2 1 1];
rule101=[2 1 5 2 1 1];
rule102=[5 1 5 2 1 1];
rule102a=[3 2 3 2 1 1];
rule102b=[3 3 1 2 1 1];
rule102c=[3 2 3 2 1 1];
rule102d=[3 4 5 2 1 1];
rule102e=[5 1 4 2 1 1];
rule102f=[3 2 4 2 1 1];
rule102g=[3 3 4 2 1 1];
rule102h=[4 3 5 2 1 1];
rule102i=[3 3 3 2 1 1];



%Brake_Softly
rule103=[1 2 4 3 1 1];
rule104=[1 2 5 3 1 1];
rule105=[1 2 3 3 1 1];
rule106=[2 2 3 3 1 1];
rule107=[2 3 3 3 1 1];
rule108=[2 3 2 3 1 1];
rule109=[2 2 2 3 1 1];
rule110=[5 2 4 3 1 1];
rule111=[5 2 5 3 1 1];
rule112=[5 2 3 3 1 1];
rule113=[4 2 3 3 1 1];
rule114=[4 3 3 3 1 1];
rule115=[4 3 2 3 1 1];
rule116=[4 2 2 3 1 1];
rule116a=[2 3 5 3 1 1];
rule116b=[5 3 4 3 1 1];
rule116c=[5 3 2 3 1 1];
rule116d=[3 3 2 3 1 1];
rule116e=[3 4 3 3 1 1];
rule116f=[3 1 1 3 1 1];
rule116g=[3 2 1 3 1 1];
rule116h=[4 3 5 3 1 1];
rule116i=[5 2 2 3 1 1];
rule116j=[1 4 5 3 1 1];
rule116k=[2 2 2 3 1 1];
rule116l=[4 4 5 3 1 1];
rule116m=[2 3 4 3 1 1];

%Maintain
rule117=[1 3 3 4 1 1];
rule118=[5 3 3 4 1 1];
rule119=[1 4 3 4 1 1];
rule120=[5 4 3 4 1 1];
rule121=[2 3 2 4 1 1];
rule122=[4 3 2 4 1 1];
rule123=[1 5 1 4 1 1];
rule124=[1 5 2 4 1 1];
rule125=[1 5 3 4 1 1];
rule126=[1 5 4 4 1 1];
rule127=[1 5 5 4 1 1];
rule128=[2 5 1 4 1 1];
rule129=[2 5 2 4 1 1];
rule130=[2 5 3 4 1 1];
rule131=[2 5 4 4 1 1];
rule132=[2 5 5 4 1 1];
rule133=[3 5 1 4 1 1];
rule134=[3 5 2 4 1 1];
rule135=[3 5 3 4 1 1];
rule136=[3 5 4 4 1 1];
rule137=[3 5 5 4 1 1];
rule138=[4 5 1 4 1 1];
rule139=[4 5 2 4 1 1];
rule140=[4 5 3 4 1 1];
rule141=[4 5 4 4 1 1];
rule142=[4 5 5 4 1 1];
rule143=[5 5 1 4 1 1];
rule144=[5 5 2 4 1 1];
rule145=[5 5 3 4 1 1];
rule146=[5 5 4 4 1 1];
rule147=[5 5 5 4 1 1];
rule147a=[1 3 2 4 1 1];
rule147b=[1 3 1 4 1 1];
rule147c=[1 1 3 4 1 1];
rule147d=[5 1 1 4 1 1];
rule147e=[1 3 5 4 1 1];
rule147f=[2 1 2 4 1 1];
rule147g=[1 3 4 4 1 1];
rule147h=[5 3 5 4 1 1];
rule147i=[1 1 1 4 1 1];
rule147j=[1 1 4 4 1 1];
rule147k=[1 1 5 4 1 1];

%Accelerate_Softly
rule148=[1 4 1 5 1 1];
rule149=[5 4 1 5 1 1];
rule150=[2 4 2 5 1 1];
rule151=[4 4 2 5 1 1];
rule151a=[5 1 2 5 1 1];

%Accelerate
rule152=[3 4 1 6 1 1];

%Compile the rules
ruleListE=[rule94;rule95;rule96;rule96a;rule96b;
    rule96c;rule96d;rule97;rule98
    rule99;rule100;rule101;rule102;rule102a;rule102b;
    rule102c;rule102d;rule102e;rule102f;rule102g;
    rule102h;rule102i;rule103;rule104;
    rule105;rule106;rule107;rule108;rule109;rule110;
    rule111;rule112;rule113;rule114;rule115;rule116;
    rule116a;rule116b;rule116c;rule116d;rule116e;
    rule116f;rule116h;rule116i;rule116j;rule116k;
    rule116l;rule116m;
    rule117;rule118;rule119;rule120;rule121;rule122;
    rule123;rule124;rule125;rule126;rule127;rule128;
    rule129;rule130;rule131;rule132;rule133;rule134;
    rule135;rule136;rule137;rule138;rule139;rule140;
    rule141;rule142;rule143;rule144;rule145;rule146;
    rule147;rule147a;rule147b;rule147c;rule147d;rule147e;
    rule147f;rule147g;rule147h;rule147i;rule147j;rule147k;
    rule148;rule149;rule150;rule151;rule151a;rule152];

e = addrule(e,ruleListE);

rules = showrule(d)

%defuzzification methods
e.defuzzMethod = 'centroid';
%e.defuzzMethod = 'bisector';
%e.defuzzMethod = 'mom';
%e.defuzzMethod = 'som';
%e.defuzzMethod = 'lom';

for i=1:size(TestData2,1)
        evalSpeed = evalfis(e, [TestData2(i, 1), TestData2(i, 3), TestData(i, 10)]);
        fprintf('%d) In(1): %.2f, In(2) %.2f, In(3) %.2f  => Out: %.2f \n\n',i,TestData2(i, 1),TestData2(i, 3),TestData(i,10), evalSpeed);  
        xlswrite('output.xls', evalSpeed, 1, sprintf('I%d',i+1));
end


%%------------------------
%%      System 6(Maneuver)
%%------------------------

f = newfis('Maneuver');

f=addvar(f,'input','ChangeOfSpeed',[0 100]);
f=addmf(f,'input',1,'Brake_Hard','trapmf',[-10 -1 10 20]);
f=addmf(f,'input',1,'Brake','trimf',[15 25 35]);
f=addmf(f,'input',1,'Brake_Softly','trimf',[30 40 50]);
f=addmf(f,'input',1,'Maintain','trimf',[40 50 60]);
f=addmf(f,'input',1,'Accelerate_Softly','trimf',[50 60 70]);
f=addmf(f,'input',1,'Accelerate','trimf',[65 75 85]);
f=addmf(f,'input',1,'Accelerate_Hard','trimf',[80 90 100 110]);


f=addvar(f,'input','InterferenceNeeded',[0 100]);
f=addmf(f,'input',2,'No','gaussmf',[30 0]);
f=addmf(f,'input',2,'Potential','trimf',[40 50 60]);
f=addmf(f,'input',2,'Yes','gaussmf',[30 100]);


f=addvar(f,'input','Object_Direction',[0 180]);
f=addmf(f,'input',3,'Far_Left','trapmf',[-1 0 20 40]);
f=addmf(f,'input',3,'Left','trimf',[35 50 65]);
f=addmf(f,'input',3,'Middle','trapmf',[60 75 105 120]);
f=addmf(f,'input',3,'Right','trimf',[115 130 145]);
f=addmf(f,'input',3,'Far_Right','trapmf',[140 160 180 181]);

f=addvar(f,'output','SuggestedManeuver',[0 100]);
f=addmf(f,'output',1,'HardLeft','trapmf',[-1 0 10 20]);
f=addmf(f,'output',1,'SoftLeft','trimf',[10 20 30]);
f=addmf(f,'output',1,'SlightBrake','trimf',[20 30 40]);
f=addmf(f,'output',1,'EmergencyStop','trapmf',[30 40 60 70]);
f=addmf(f,'output',1,'SoftRight','trimf',[60 70 80]);
f=addmf(f,'output',1,'HardRight','trimf',[70 80 90]);
f=addmf(f,'output',1,'NoManeuver','trapmf',[80 90 100 101]);

%%Declare the rules
%HardLeft
rule153=[1 3 4 1 1 1];

%SoftLeft
rule154=[2 3 3 2 1 1];
rule155=[2 3 4 2 1 1];
rule156=[2 2 3 2 1 1];
rule157=[2 2 4 2 1 1];

%SlightBrake
rule158=[3 2 1 3 1 1];
rule159=[3 2 2 3 1 1];
rule160=[3 2 3 3 1 1];
rule161=[3 2 4 3 1 1];
rule162=[3 2 5 3 1 1];
rule163=[3 3 1 3 1 1];
rule164=[3 3 5 3 1 1];

%EmergencyStop
rule165=[1 3 2 4 1 1];
rule166=[1 3 3 4 1 1];
rule167=[1 3 4 4 1 1];

%SoftRight
rule168=[2 3 1 5 1 1];
rule169=[2 3 2 5 1 1];
rule170=[2 3 3 5 1 1];
rule171=[2 2 1 5 1 1];
rule172=[2 2 2 5 1 1];

%HardRight
rule173=[1 3 2 6 1 1];

%NoManeuver
rule174=[4 1 1 7 1 2];

%Compile the rules
ruleListF=[rule153;rule154;rule155;rule156;
    rule157;rule158;rule159;rule160;rule161;
    rule162;rule163;rule164;rule165;rule166;
    rule167;rule168;rule169;rule170;rule171;
    rule172;rule173;rule174];

%Add the rule list
f = addrule(f,ruleListF);

rules = showrule(f)

%defuzzification methods
f.defuzzMethod = 'centroid';
%f.defuzzMethod = 'bisector';
%f.defuzzMethod = 'mom';
%f.defuzzMethod = 'som';
%f.defuzzMethod = 'lom';

for i=1:size(TestData2,1)
        evalSpeed = evalfis(f, [TestData2(i, 9), TestData2(i, 7), TestData2(i, 1)]);
        fprintf('%d) In(1): %.2f, In(2) %.2f, In(3) %.2f  => Out: %.2f \n\n',i,TestData2(i, 9),TestData2(i, 7),TestData2(i,1), evalSpeed);  
        xlswrite('output.xls', evalSpeed, 1, sprintf('K%d',i+1));
end

figure(1)
subplot(6,1,1), plotmf(a, 'input', 1)
subplot(6,1,2), plotmf(a, 'input', 2)
subplot(6,1,3), plotmf(a, 'input', 3)
subplot(6,1,4), plotmf(a, 'input', 4)
subplot(6,1,5), plotmf(a, 'input', 5)
subplot(6,1,6), plotmf(a, 'output', 1)

figure(2)
subplot(3,1,1), plotmf(b,'input',1)
subplot(3,1,2), plotmf(b,'input',2)
subplot(3,1,3), plotmf(b,'output',1)

figure(3)
subplot(3,1,1), plotmf(c,'input',1)
subplot(3,1,2), plotmf(c,'input',2)
subplot(3,1,3), plotmf(c,'output',1)

figure(4)
subplot(3,1,1), plotmf(d,'input',1)
subplot(3,1,2), plotmf(d,'input',2)
subplot(3,1,3), plotmf(d,'output',1)

figure(5)
subplot(4,1,1), plotmf(e,'input',1)
subplot(4,1,2), plotmf(e,'input',2)
subplot(4,1,3), plotmf(e,'input',3)
subplot(4,1,4), plotmf(e,'output',1)

figure(6)
subplot(4,1,1), plotmf(f,'input',1)
subplot(4,1,2), plotmf(f,'input',2)
subplot(4,1,3), plotmf(f,'input',3)
subplot(4,1,4), plotmf(f,'output',1)
