IR_recon = reconstruct_IR_from_estimates(A(1:25,:), md, tau, 10);
antenna_idx = 1;
figure;
plot(tau*1e9, real(IR_12(:,antenna_idx)), 'r', ...
     tau*1e9, real(IR_recon(:,antenna_idx)), 'b--');
xlabel('Thời gian (ns)'); ylabel('Biên độ');
legend('IR_{12} thực', 'IR tái tạo');
title(['So sánh tín hiệu tại anten ', num2str(antenna_idx)]);
error = norm(IR_recon - IR_12, 'fro') / norm(IR_12, 'fro');
fprintf("Sai số tương đối giữa IR tái tạo và IR gốc: %.4f (%.2f%%)\n", error, error*100);


function IR_recon = reconstruct_IR_from_estimates(A, md, tau, num_antennas)
    % A: ma trận thông số (N x 7) [tau, phi_1, theta_1, phi_2, theta_2, fd, alpha]
    % md: thông tin pulse (md.type, md.Tp, md.beta)
    % tau: trục thời gian (15000x1)
    % num_antennas: số anten (ví dụ: 10)

    N = size(A, 1);  % số sóng đã ước lượng
    IR_recon = zeros(length(tau), num_antennas);  % tái tạo IR

    for i = 1:N
        tau_i     = A(i, 1);
        phi_1     = A(i, 2);
        theta_1   = A(i, 3);
        phi_2     = A(i, 4);
        theta_2   = A(i, 5);
        fd_i      = A(i, 6);
        alpha_i   = A(i, 7);

        % Tạo xung tại tau_i
        u = generatePulse(md, tau_i, tau, 3);  % chuẩn hóa năng lượng

        % Vector hướng truyền và thu
        c1 = calculate_c_omega_1([cos(phi_1), sin(phi_1)], theta_1);  % (num_antennas x 1)
        c2 = calculate_cH_omega_2([cos(phi_2), sin(phi_2)], theta_2); % (1 x num_antennas)

        % Pha Doppler
        doppler_phase = exp(1j * 2 * pi * fd_i * tau);  % (15000 x 1)

        % Tái tạo sóng: s = alpha * exp(j2πfd·t) * c1 * c2 * u'
        s = alpha_i * (c1 * c2) .* (doppler_phase .* u);  % (15000 x num_antennas)
        IR_recon = IR_recon + s;
    end
end

