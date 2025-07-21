% function cH_phi = calculate_c_omega_1(omega_0, theta_1)
% 
% % Khởi tạo các biến và thông số
% lambda = 1; % Bước sóng
% load("pos.mat", "pos_centers")
% I = 10;
% r_m = pos_centers(:, 11:20)';
% for m = 1:I
%     c_m(m) = sqrt(sin(theta_1)) * exp(1j * 2 * pi * lambda^(-1) * dot(conj(omega_0)', r_m(m, :)));
% end
% 
% % Transpose để có hàm c(phi) là ma trận kích thước [I x length(phi)]
% cH_phi = c_m;
% end
% 
% % 10 máy thu  OMEGA_1 là máy thu
function cH_phi = calculate_c_omega_1(omega_0, theta_1)
    lambda = 1;
    load("pos.mat", "pos_centers");
    r_m = pos_centers(:, 11:20)';  % [10 x 2] ← 10 anten thu

    c_m = zeros(1, size(r_m,1));
    omega_0 = reshape(omega_0, 1, []);  % ép thành hàng [1 x 2]
    for m = 1:size(r_m,1)
        phase = sum(conj(omega_0) .* r_m(m, :));  % dot 2D
        c_m(m) = sqrt(sin(theta_1)) * exp(1j * 2 * pi / lambda * phase);
    end
    cH_phi = c_m;  % [1 x 10]
end
