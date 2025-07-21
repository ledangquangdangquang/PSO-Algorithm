clc; clear;
load("IR_12.mat", "IR_12");

A = zeros(25, 7); % [tau, phi_1, theta_1, phi_2, theta_2, doppler, alpha]
B = zeros(25, 2); % [phi_1, theta_1]
C = zeros(25, 2); % [phi_2, theta_2]

IR_3 = IR_12;
IR_4 = IR_12;

tau = (0:4.6414e-12:14999*4.6414e-12)'; % [15000 x 1] trục thời gian

% Cấu hình xung phát
md.type = 'RRC';
md.Tp = 0.5e-9;
md.beta = 0.6;

for i = 1:25
    fprintf('....Step %d\n', i);

    % Ước lượng tau
    A(i, 1) = psoT(IR_3);
    u = generatePulse(md, A(i, 1), tau, 0);

    fprintf("‖u‖ = %.4e, max|u| = %.4e\n", norm(u), max(abs(u)));

    % Hiển thị xung tương quan và vị trí tau ước lượng
    figure(1); clf;
    plot(tau, abs(IR_3(:,1)));
    hold on;
    xline(A(i,1), 'r--', 'LineWidth', 2);
    title(sprintf("Tau estimated: %.2e", A(i,1)));

    % Ước lượng góc tại máy thu
    [B(i,:), A(i,3), A(i,2)] = psoOmega_1(u, IR_3, tau); % [phi_1, theta_1]

    % Ước lượng góc tại máy phát
    [C(i,:), A(i,5), A(i,4)] = psoOmega_2(u, IR_4, tau); % [phi_2, theta_2]

    % Ước lượng Doppler
    A(i,6) = psoV(u, IR_3, B(i,:), C(i,:), A(i,1));

    % Ước lượng alpha
    A(i,7) = alpha_1(u, IR_3, B(i,:), C(i,:), A(i,3), A(i,5), A(i,6), A(i,1));

    % Tính omega_1 (2D)
    phi_1 = B(i,1);
    omega_1 = [cos(phi_1), sin(phi_1)];

    % Triệt tiêu tại phía thu
    IR_3 = calculate_XL_omega_1(u, IR_3, omega_1, A(i,3), A(i,7), A(i,6));

    % Tính omega_2 (2D)
    phi_2 = C(i,1);
    omega_2 = [cos(phi_2), sin(phi_2)];

    % Triệt tiêu tại phía phát
    IR_4 = calculate_XL_omega_2(u, IR_4, omega_2, A(i,5), A(i,7), A(i,6));

    fprintf("Step %d: ‖IR_3‖ = %.4e, ‖IR_4‖ = %.4e, alpha = %.4e\n", ...
        i, norm(IR_3(:)), norm(IR_4(:)), A(i,7));
end
