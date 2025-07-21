function objective_value = alpha_1(u, IR_3, omega_1, omega_2, theta_1, theta_2, v0, tau)
    % Tính vector điều hướng phía thu
    a1 = calculate_c_omega_1(omega_1, theta_1);  % [1 x 10]

    % Tính vector điều hướng phía phát (scalar)
    a2 = calculate_cH_omega_2(omega_2, theta_2);  % [scalar]

    % Tích vô hướng toàn hệ thống (kênh truyền)
    c = a1 * a2;  % [1 x 10] * scalar = [1 x 10]

    % Điều chế Doppler
    exp_doppler = exp(-1j * 2 * pi * v0 * tau);  % [15000 x 1]
    u_dopp = u .* exp_doppler;                  % [15000 x 1]

    % Ước lượng alpha từng kênh
    integral_value = zeros(10, 1);
    for i = 1:10
        s = u_dopp * c(i);        % [15000 x 1]
        y = IR_3(:, i);           % [15000 x 1]
        num = sum(conj(s) .* y);  % inner product
        denom = sum(abs(s).^2);   % năng lượng s
        integral_value(i) = num / denom;
        fprintf("  [i=%d] alpha_est = %.4e + %.4ei\n", i, real(integral_value(i)), imag(integral_value(i)));
    end

    % Trả về trung bình alpha
    objective_value = mean(integral_value);
    fprintf("  => alpha (mean) = %.8e + %.8ei\n", real(objective_value), imag(objective_value));
end
