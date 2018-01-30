%Script for Calibration
clear all;
clc;
%%
%Calibrating Bt
% one sensor position, D magnets positions
sensor_position_desired = [0;0;0];
sensor_position_actual = [1;0;2] * 1e-3;

rotation_angle = 10 * pi/180; %the rotation angle is 10degree
% sensor_rotation_desired = [1,0,0; 0,1,0; 0,0,1]; 
% sensor_rotation_actual = [
%     cos(rotation_angle), -sin(rotation_angle), 0;
%     sin(rotation_angle), cos(rotation_angle), 0;
%     0,0,1
%     ];

sensor_rotation_angle_desired = [0;0;0];
sensor_rotation_angle_actual = [0;0;rotation_angle];
sensor_rotation_desired = YawMatrix(sensor_rotation_angle_desired(3)) * PitchMatrix(sensor_rotation_angle_desired(2)) * RollMatrix(sensor_rotation_angle_desired(1));
sensor_rotation_actual = YawMatrix(sensor_rotation_angle_actual(3)) * PitchMatrix(sensor_rotation_angle_actual(2)) * RollMatrix(sensor_rotation_angle_actual(1));

Bt_actual = 1.6211e-7;
noise_level = 2e-7;

magnet_position = Generate_Magnet_Position(7, 10e-3);

Measured_data_Bt = zeros(3, size(magnet_position, 2));
for i = 1:size(magnet_position, 2)
%     Measured_data_Bt(:,i) = GenerateSensorData(sensor_position_actual, magnet_position(:,i), Bt_actual, noise_level);
    Measured_data_Bt(:,i) = sensor_rotation_actual * GenerateSensorData(sensor_position_actual, magnet_position(:,i), Bt_actual, noise_level);
end

%LM optimization
LMoptions = optimoptions(@lsqnonlin);
LMoptions.Display = 'iter';
LMoptions.Algorithm = 'levenberg-marquardt';
LMoptions.StepTolerance = 1e-10;
LMoptions.MaxFunctionEvaluations = 1000;

Bt0 = 100e-7;
Bt_retrieval = lsqnonlin(@(Bt) BtError(Bt, sensor_position_desired, magnet_position, Measured_data_Bt), Bt0, [], [], LMoptions);

%%
%Calibration Sensor Position
Bt = Bt_retrieval;
sensor_position_0 = [0;0;0];
sensor_position_retrieval = lsqnonlin(@(sensor_position) SensorPositionError(sensor_position, Bt, magnet_position, Measured_data_Bt), sensor_position_0, [], [], LMoptions);

%%
% Calibration SensorRotation

% % It turns out that using nonlinear constraints cannot get a good rotation results 
% TRoptions = optimoptions(@fmincon);
% TRoptions.Algorithm = 'active-set';
% TRoptions.ConstraintTolerance = 1e-5;
% TRoptions.Display = 'iter';
% TRoptions.MaxIterations = 300;
% TRoptions.MaxFunctionEvaluations = 1000;
% TRoptions.StepTolerance = 1e-6;
% TRoptions.OptimalityTolerance = 1e-6;
% 
% lb = [];
% ub = [];
% A = [];
% b = [];
% Aeq = [];
% beq = [];
% nonlcon = @(sensor_rotation) normalizeCon(sensor_rotation); %provide nonlinear constraints

% % try pitch-yaw-roll angle


Bt = Bt_retrieval;
sensor_position = sensor_position_retrieval;

% sensor_rotation_0 = sensor_rotation_desired;
% sensor_rotation_retrieval = fmincon(@(sensor_rotation) SensorRotationError(sensor_rotation, Bt, sensor_position, magnet_position, Measured_data_Bt), sensor_rotation_0, A, b, Aeq, beq, lb, ub, nonlcon, TRoptions);

% sensor_rotation_retrieval = lsqnonlin(@(sensor_rotation) SensorRotationError(sensor_rotation, Bt, sensor_position, magnet_position, Measured_data_Bt), sensor_rotation_0, [], [], LMoptions);

sensor_rotation_0 = sensor_rotation_angle_desired;
sensor_rotation_retrieval = lsqnonlin(@(sensor_rotation) SensorRotationErrorAngle(sensor_rotation, Bt, sensor_position, magnet_position, Measured_data_Bt), sensor_rotation_0, [], [], LMoptions);

%%
%Error function

%BtError
function Error = BtError(Bt, sensor_position_desired, magnet_position, Measured_data_Bt)
    
    Theory_data_Bt = zeros(3, size(magnet_position, 2));
    for i = 1:size(magnet_position, 2)
        Theory_data_Bt(:, i) =  MagneticSensorValue(magnet_position(:,i), sensor_position_desired);
    end
    
    E_matrix = Measured_data_Bt / Bt - Theory_data_Bt;
    
    Error = sum(E_matrix(1,:) .^2) + sum(E_matrix(2,:) .^2) + sum(E_matrix(3,:) .^2);
end

%SensorPositionError
function Error = SensorPositionError(sensor_position, Bt, magnet_position, Measured_data_Bt)
    
    Theory_data_Bt = zeros(3, size(magnet_position, 2));
    for i = 1:size(magnet_position, 2)
        Theory_data_Bt(:, i) =  MagneticSensorValue(magnet_position(:,i), sensor_position);
    end
    
    E_matrix = Measured_data_Bt / Bt - Theory_data_Bt;
    
    Error = sum(E_matrix(1,:) .^2) + sum(E_matrix(2,:) .^2) + sum(E_matrix(3,:) .^2);
    
end

%SensorRotationError
function Error = SensorRotationError(sensor_rotation, Bt, sensor_position, magnet_position, Measured_data_Bt)
    
    Theory_data_Bt = zeros(3, size(magnet_position, 2));
    for i = 1:size(magnet_position, 2)
        Theory_data_Bt(:, i) =  sensor_rotation * MagneticSensorValue(magnet_position(:,i), sensor_position);
    end
    
    E_matrix =  Measured_data_Bt / Bt - Theory_data_Bt;
    
    Error = sum(E_matrix(1,:) .^2) + sum(E_matrix(2,:) .^2) + sum(E_matrix(3,:) .^2);
    
end


function Error = SensorRotationErrorAngle(sensor_rotation, Bt, sensor_position, magnet_position, Measured_data_Bt)
    
    rotation = YawMatrix(sensor_rotation(3)) * PitchMatrix(sensor_rotation(2)) * RollMatrix(sensor_rotation(1));

    Theory_data_Bt = zeros(3, size(magnet_position, 2));
    for i = 1:size(magnet_position, 2)
        Theory_data_Bt(:, i) =  rotation * MagneticSensorValue(magnet_position(:,i), sensor_position);
    end
    
    E_matrix =  Measured_data_Bt / Bt - Theory_data_Bt;
    
    Error = sum(E_matrix(1,:) .^2) + sum(E_matrix(2,:) .^2) + sum(E_matrix(3,:) .^2);
    
end

% %SensorRotationError constraints, remove the comment when use TR
% function [c, ceq] = normalizeCon(sensor_rotation)
%     c = [];
%     ceq = norm(sensor_rotation) -1;
% end

