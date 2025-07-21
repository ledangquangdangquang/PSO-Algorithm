function objective_value = alpha_2(u, IR_3, omega_1, omega_2, theta_1, theta_2, v0, tau)
    md.type = 'RRC';
    md.Tp = 0.5e-9;
    md.beta = 0.6;

    Ta = md.Tp / 15000;
    Pu = calculate_power(u);

    % Cần kiểm tra tính đúng đắn của các hàm này
    c1 = calculate_c_omega_1(omega_1, theta_1);
    c2 = calculate_cH_omega_2(omega_2, theta_2);
    c_omega = norm(c1) * norm(c2);

    IPS = 1 / (10 * c_omega * Ta * Pu);

    integral_value = zeros(10, 1);
    exp_phase = exp(-1j * 2 * pi * v0 * tau);  % Tính theo thời gian

    for i = 1:10
        c = dot(omega_1, omega_2);
        mul = u(:, 1) .* exp_phase .* c .* IR_3(:, i);
        integral_value(i) = trapz(tau, mul);
    end

    sum_columns = sum(integral_value);
    result = IPS * sum_columns;

    objective_value = round(result, 8);
    fprintf('Pu = %.3e, ‖c1‖ = %.3e, ‖c2‖ = %.3e, IPS = %.3e\n', Pu, norm(c1), norm(c2), IPS);
    fprintf('sum(abs(u).^2) = %.4e\n', sum(abs(u).^2));
    fprintf('‖IR_3(:,1)‖ = %.4e\n', norm(IR_3(:,1)));
    fprintf('v0 = %.4e, dot(omega_1, omega_2) = %.4e\n', v0, dot(omega_1, omega_2));

end
