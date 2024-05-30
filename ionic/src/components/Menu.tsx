import React from 'react';
import { CgAddR, CgQr, CgUser } from "react-icons/cg";
import { Link } from 'react-router-dom';
import './MenuComp.css';


interface ContainerProps { }


const Menu: React.FC<ContainerProps> = () => {


    return (
        <div id="menu">
            <Link to="/principal">
                <CgQr id='icones' />
            </Link>
            <Link to="/users">
                <CgUser id='icones' />
            </Link>
            <Link to="/agregar">
                <CgAddR id='icones' />
            </Link>
        </div>
    );
};

export default Menu;