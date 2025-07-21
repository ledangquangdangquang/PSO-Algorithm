function [objective_value, omega_1] = objective_function_omega_1(u, variables, IR_3, tau)
    % u      : [15000 x 1]
    % IR_3   : [15000 x 10]
    % tau    : [15000 x 1]
    % variables = [phi_1, theta_1]

    phi_1 = variables(1);
    theta_1 = variables(2);

    % Vector hướng sóng tới (2D)
    omega_1 = [cos(phi_1), sin(phi_1)];

    % Vector điều hướng tại máy thu (10 anten)
    cH_phi_1 = calculate_c_omega_1(omega_1, theta_1);  % [1 x 10]

    % Tính tích phân từng anten
    result = zeros(10, 1);
    for i = 1:10
        s = u * cH_phi_1(i);          % [15000 x 1]
        y = IR_3(:, i);               % [15000 x 1]
        val = trapz(tau, s .* conj(y));
        result(i) = abs(val)^2;      % giá trị thực dương
    end

    % Tổng toàn kênh
    objective_value = sum(result);   % không cần round
end

% function [objective_value, omega_1] = objective_function_omega_1(u, variables, IR_3, tau)
% 
% % Giả định hàm mục tiêu nhận các biến và tính giá trị mục tiêu
% % variables là vecto
% phi_1 = variables(1);
% theta_1 = variables(2);
% 
% % Tính toán omega_1 và omega_2
% omega_1 = [cos(phi_1) * sin(theta_1), sin(phi_1) * sin(theta_1)];
% 
% % Tính toán cH_phi_1
% cH_phi_1 = calculate_c_omega_1(omega_1, theta_1)';
% 
% % Tính toán giá trị tích phân và hàm mục tiêu
% result = zeros(10, 1);
% integral_value = zeros(10, 1);
% for i = 1
%     c = cH_phi_1(i, :);
%     mul = u(:, 1) * c .* IR_3(:, i);
%     integral_value(i) = trapz(tau, mul);
%     % Sum the squared absolute values of integral value
%     a = real(integral_value(i));
%     b = imag(integral_value(i));
%     result(i) = a*a + b*b;
% end
% 
% % Tổng các kết quả cuối cùng
% sum_columns = sum(result);
% 
% % Trả về giá trị của hàm
% objective_value = round(sum_columns, 8);
% end
