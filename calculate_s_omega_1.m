function s = calculate_s_omega_1(u, omega_1, theta_1, alpha, v)
    c = calculate_c_omega_1(omega_1, theta_1);% 1x10
    s = alpha * exp(1j*2*pi*v) * u * c; % 15000x10
end
