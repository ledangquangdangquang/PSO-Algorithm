% function XL = calculate_XL_omega_2(u, IR_12, omega_2, theta_2, alpha, v)
%     c = calculate_cH_omega_2(omega_2, theta_2);
%     s = alpha * exp(1j*2*pi*v) * u * c;
%     XL = IR_12 - s;
% 
% end
function XL = calculate_XL_omega_2(u, IR_12, omega_2, theta_2, alpha, v)
    % u: [15000 x 1]
    % IR_12: [15000 x 10]
    % omega_2: [1 x 2] (vector hướng sóng phát ra)

    lambda = 1;
    tau = (0:length(u)-1)' * 4.6414e-12;  % [15000 x 1]

    load("VA.mat", "used_VAs");
    r_tx = -used_VAs{1,1}(:,1);  % [2 x 1], tọa độ anten phát
    r_tx = reshape(r_tx, 1, []); % [1 x 2]
    omega_2 = reshape(omega_2, 1, []);

    % Tính vector điều hướng phát (scalar vì chỉ 1 anten)
    phase = sum(conj(omega_2) .* r_tx);  % dot 2D
    c = sqrt(sin(theta_2)) * exp(1j * 2 * pi / lambda * phase);  % scalar

    exp_dopp = exp(1j * 2 * pi * v * tau);  % [15000 x 1]
    u_dopp = u .* exp_dopp;                % [15000 x 1]

    s = alpha * u_dopp * c;  % [15000 x 1]
    XL = IR_12 - s;          % [15000 x 10] - [15000 x 1] → MATLAB broadcasting
end
