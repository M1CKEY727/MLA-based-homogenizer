function n=calRI(formula,coe,lambda)
    switch formula
        case 1%Schott
            n=sqrt(coe(1)+coe(2).*lambda.^2+coe(3).*lambda.^(-2)+ ...
                coe(4).*lambda.^(-4)+coe(5).*lambda.^(-6)+coe(6).*lambda.^(-8));
        case 2%Sellmeier 1
            n = (1 + coe(1) * lambda.^2 ./ (lambda.^2 - coe(2)) + coe(3) * lambda.^2 ./ (lambda.^2 - coe(4)) + coe(5) * lambda.^2. / (lambda.^2 - coe(6))).^0.5;
        case 3%Herzberger
            L=1./(lamgbda.^2-0.028);
            n=coe(1)+coe(2)*L+coe(3)*L.^2+coe(4)*lambda.^2+coe(5)*lambda.^4+coe(6)*lambda.^6;
        case 4%Sellmeier 2

        case 5%Conrady
            n=coe(1)+coe(2)./lambda+coe(3)./(lambda.^3.5);
        case 6%Sellmeier 3
            n = (1 + coe(1) * lambda.^2 ./ (lambda.^2 - coe(2)) + coe(3) * lambda.^2 ./ (lambda.^2 - coe(4)) + coe(5) * lambda.^2. / (lambda.^2 - coe(6))+coe(7) * lambda.^2 ./ (lambda.^2 - coe(8))).^0.5;
        case 7%Handbook of Optics 1
            n=sqrt(coe(1)+coe(2)./(lambda.^2-coe(3))-coe(4)*lambda.^2);
        case 8%Handbook of Optics 2
            n=sqrt(coe(1)+coe(2).*lambda.^2./(lambda.^2-coe(3))-coe(4)*lambda.^2);
        case 9%Sellmeier 4
            n=sqrt(coe(1) + coe(2) * lambda.^2 ./ (lambda.^2 - coe(3)) + coe(4) * lambda.^2. / (lambda.^2 - coe(5)));
        case 10%Extended
            n=sqrt(coe(1)+coe(2).*lambda.^2+coe(3).*lambda.^(-2)+coe(4).*lambda.^(-4)+coe(5).*lambda.^(-6)+coe(6).*lambda.^(-8)+coe(7).*lambda.^(-10)+coe(8).*lambda.^(-12));
        case 11%Sellmeier 5
            n = sqrt(1 + coe(1) * lambda.^2 ./ (lambda.^2 - coe(2)) + coe(3) * lambda.^2 ./ (lambda.^2 - coe(4)) + coe(5) * lambda.^2 ./ (lambda.^2 - coe(6))+coe(7) * lambda.^2 ./ (lambda.^2 - coe(8))+coe(9) * lambda.^2 ./ (lambda.^2 - coe(10)));
        case 12%Extended 2
            n=sqrt(coe(1)+coe(2).*lambda.^2+coe(3).*lambda.^(-2)+coe(4).*lambda.^(-4)+coe(5).*lambda.^(-6)+coe(6).*lambda.^(-8)+coe(7).*lambda.^4+coe(8).*lambda.^6);
        case 13%Extended 3
            n=sqrt(coe(1)+coe(2).*lambda.^2+coe(3).*lambda.^4+coe(4).*lambda.^(-2)+coe(5).*lambda.^(-4)+coe(6).*lambda.^(-6)+coe(7).*lambda.^(-8)+coe(8).*lambda.^(-10)++coe(9).*lambda.^(-12));
    end
end