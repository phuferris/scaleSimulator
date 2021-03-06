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

global bufferSize;
global wakeup_power;
global active_sleep_periods;

%=======================================

numNodes = 25;
numAPs = 25;
initial_power = 1100; % 4400mAh - 5V @ 1A
wireless_range = 70; % 100 feets

broadcast_message_size = 0.1; % Mb
beacon_message_size = 0.3; % Mb

sleeping_power = 0.005; % mAh per sec
active_power = 0.05; % mAh per sec
sending_power = 1; % Mb per mAh
receiving_power = 0.1; % Mb per mAh

computation_power = 0.005; % mAh

maxx = 250; % feet
maxy = 250; % feet
maxEvents = 5000;
eventsPeriod = 3600; % 3600 second or 1 hour

maxRandomSleepingTime = 10; % 10 second;
maxRandomActiveTime = 10; % 10 second;

bufferSize = 100; % 100 events max
wakeup_power = 0.9;  % mAh

active_sleep_periods = [5,6,7,8,9,10,11,12,13,14,15;5,6,7,8,9,10,11,12,13,14,15];
