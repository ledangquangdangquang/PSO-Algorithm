% function XL = calculate_XL_omega_1(u, IR_12, omega_1, theta_1, alpha, v)
%     c = calculate_c_omega_1(omega_1, theta_1);% 1x10
%     s = alpha * exp(1j*2*pi*v) * u * c; % 15000x10
%     XL = IR_12 - s;
% end
function XL = calculate_XL_omega_1(u, IR_12, omega_1, theta_1, alpha, v)
    % u: [15000 x 1]
    % IR_12: [15000 x 10]
    % omega_1: [1 x 2] (vector hướng sóng tới tại máy thu)
    
    lambda = 1;
    tau = (0:length(u)-1)' * 4.6414e-12;  % [15000 x 1]
    
    load("pos.mat", "pos_centers");
    r_m = pos_centers(:, 11:20)';  % [10 x 2] vị trí các anten thu

    % Tính vector điều hướng [1 x 10]
    c = zeros(1, size(r_m,1));
    omega_1 = reshape(omega_1, 1, []);
    for m = 1:size(r_m,1)
        phase = sum(conj(omega_1) .* r_m(m,:));  % dot 2D
        c(m) = sqrt(sin(theta_1)) * exp(1j * 2 * pi / lambda * phase);
    end

    % Pha Doppler
    exp_dopp = exp(1j * 2 * pi * v * tau);  % [15000 x 1]
    u_dopp = u .* exp_dopp;                % [15000 x 1]

    s = alpha * u_dopp * c;  % [15000 x 1] * [1 x 10] → [15000 x 10]

    XL = IR_12 - s;  % Loại bỏ thành phần đã ước lượng
end
