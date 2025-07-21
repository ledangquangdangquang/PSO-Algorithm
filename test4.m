xxx = calculate_c_omega_1(B(1,:), pi/2);
yyy = calc_c(299.169641, pi/2).';
disp( xxx);
disp( yyy);
%%
function cH_phi = calculate_c_omega_1(omega_0, theta_1)

% Khởi tạo các biến và thông số
lambda = 1; % Bước sóng
load("pos.mat", "pos_centers")
I = 10;
r_m = pos_centers(:, 11:20)';
for m = 1:I
    c_m(m) = sqrt(sin(theta_1)) * exp(1j * 2 * pi * lambda^(-1) * dot(conj(omega_0)', r_m(m, :)));
end

% Transpose để có hàm c(phi) là ma trận kích thước [I x length(phi)]
cH_phi = c_m; % 1x10
end
%%
function c_phi = calc_c(phi, theta)
    lambda = 1; 
    load("pos.mat", "pos_centers")
    antenna_pos = pos_centers(:, 11:20)';  % Mx2

    % Vector hướng sóng
    u_phi = [cos(phi) * sin(theta); sin(phi) * sin(theta)];  % 2x1

    % Phase shift mỗi anten
    phase_shifts = 2 * pi / lambda * (antenna_pos * u_phi);  % Mx1

    % Vector hướng không gian (steering vector)
    c_phi = exp(1j * phase_shifts);

    % %  Thêm dòng này để chuẩn hóa
    % c_phi = c_phi / norm(c_phi);
end
