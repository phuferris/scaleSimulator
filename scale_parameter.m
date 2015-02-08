% clear;

%=======================================
% Global parameters
global numNodes;
global numAPs;
global initial_power;
global wireless_range;

global broadcast_message_size;
global beacon_message_size;
global sleeping_power;
global active_power;
global sending_power;
global receiving_power; % Mb per mAh
global computation_power;

global maxx;
global maxy;
global maxEvents;
global eventsPeriod;
global maxRandomSleepingTime;
global maxRandomActiveTime;
global sentEvents;

%=======================================

numNodes = 25;
numAPs = 25;
initial_power = 4400; % 4400mAh - 5V @ 1A
wireless_range = 50; % 50 feets

broadcast_message_size = 0.1; % Mb
beacon_message_size = 0.3; % Mb

sleeping_power = 0.001; % mAh per sec
active_power = 0.01; % mAh per sec
sending_power = 0.2; % Mb per mAh
receiving_power = 0.1; % Mb per mAh

computation_power = 0.005; % mAh

maxx = 250; % feet
maxy = 250; % feet
maxEvents = 5000;
eventsPeriod = 3600; % 3600 second or 1 hour

maxRandomSleepingTime = 5; % 5 second;
maxRandomActiveTime = 5; % 5 second;

