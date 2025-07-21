clc; clear; close all;

% Thông số y(t) = cos(wt + p)
f = 1;                % Tần số tín hiệu (Hz)
T = 1 / f;            % Chu kỳ tín hiệu
w = 2 * pi * f;       % Tần số góc
p = pi / 3;           % Pha ban đầu

% Thông số quét: Tqt (thuận), Tqn (ngược)
n1 = 1.5;             % Tqt = n1 * T
n2 = 0.75;            % Tqn = n2 * T
Tp = n1 * T;          % Chu kỳ quét thuận
Tn = n2 * T;          % Chu kỳ quét ngược
total_time = Tp + Tn;

% Tính số pha (chu kỳ quét) để vẽ
frac = rats(total_time / T);   % chuyển về phân số
den = str2double(regexp(frac, '/(\d+)', 'tokens', 'once'));
if isnan(den)
    den = 1;
end
phase_count = den * 2;

samples_per_phase = 500;       % số mẫu trên mỗi pha

% Tạo dữ liệu
real_times = [];
real_signal = [];
dir_line_times = [];
dir_line_values = [];

current_time = 0;

figure;
tiledlayout(3, 1);

% Đồ thị 1: Oscilloscope
title('Oscilloscope: y(x)');
hold on;
xlim([-1, 1]);
ylim([-1.5, 1.5]);
grid on;

for i = 1:phase_count
    is_positive = mod(i, 2) == 1;
    duration = Tp * is_positive + Tn * (~is_positive);

    t = linspace(current_time, current_time + duration, samples_per_phase);
    y = cos(w * t + p);

    if is_positive
        x = linspace(-1, 1, samples_per_phase);
        plot(x, y, 'b', 'LineWidth', 1.2);
    else
        x = linspace(1, -1, samples_per_phase);
        plot(x, y, 'r--', 'LineWidth', 1.2);
    end

    % Lưu dữ liệu để vẽ các đồ thị khác
    real_times = [real_times, t];
    real_signal = [real_signal, cos(w * t + p)];
    dir_line_times = [dir_line_times, t];
    dir_line_values = [dir_line_values, x];

    current_time = current_time + duration;
end

% Đồ thị 2: y(t)
nexttile;
plot(real_times, real_signal, 'k');
title('y(t) = sin(wt + p)');
ylim([-1.5, 1.5]);
grid on;

% Đồ thị 3: x(t) – xung răng cưa
nexttile;
plot(dir_line_times, dir_line_values, 'g');
title('x(t): sóng răng cưa');
ylim([-1.1, 1.1]);
grid on;
