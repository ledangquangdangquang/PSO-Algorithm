function objective_value = objective_function_alpha_1(u, IR_3, omega_1, omega_2, theta_1, theta_2, v0, tau)
    md.type = 'RRC'; % Xung RRC
    md.Tp = 0.5e-9; % = 1/ băng thông (băng thông 2GHz)
    md.beta = 0.6; %  Hệ số giảm tốc 
    
    Ta = md.Tp / 15000;
    Pu = calculate_power(u);
    c_omega = (norm(calculate_c_omega_1(omega_1, theta_1))) * (norm(calculate_cH_omega_2(omega_2, theta_2)));
    IPS = 1/(10 * c_omega * Ta * Pu);
    % Tính toán giá trị tích phân và hàm mục tiêu
    integral_value = zeros(10, 1);
    for i = 1:10
        c = dot(omega_1, omega_2);
        mul = u(:, 1) * exp(-1j * 2 * pi * v0) * c .* IR_3(:, i);
        integral_value(i) = trapz(tau, mul);
    end
    
    % Tổng các kết quả cuối cùng
    sum_columns = sum(integral_value);
    result = IPS * sum_columns;
    
    % Trả về giá trị của hàm
    [max_val, best_index] = max(integral_value);
    objective_value = round(result, 8);
end
