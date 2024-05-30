import { get, ref } from "firebase/database";
import React, { useState } from 'react';
import { useHistory } from 'react-router-dom';
import { database } from '../firebaseConfig';
import './ExploreContainer.css';
import './MenuComp.css';
import MyContext from './MyContext';

interface ContainerProps { }

const Login: React.FC<ContainerProps> = () => {

    const { myVariable, setMyVariable } = React.useContext(MyContext);


    const history = useHistory();
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');

    const handleButtonClick = async () => {
       // event.preventDefault(); 

        try {
            const db = database;
            const usersRef = ref(db, 'usuarios');
            const snapshot = await get(usersRef);
            const usersData = snapshot.val();

            const user = Object.values(usersData).find((user: any) => user.email === username && user.password === password);

            if (user) {
                console.log("Usuario autenticado", user);
                history.push('/principal');
                alert('Login correcto');
            } else {
                console.log("No autenticado");
                alert('Login incorrecto\nPrueba de nuevo');
            }
        } catch (error) {
            console.error("Error fetching user data:", error);
        }
    };

    const handleContext = () => {
        setMyVariable(username);
        console.log(myVariable);
    };


    return (
        <>
        <div id="containerLog">
            <div id='cuadroLog'>
                <strong>Mi Transssssssporte</strong>
                <form id='formPa'>
                    <div id="input-group">
                        <input
                            type="text"
                            id="username"
                            name="username"
                            placeholder="Insertar Usuario"
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                            required
                        />
                    </div>
                    <div id="input-group">
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Insertar Contraseña"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                        />
                    </div>
                    <button type="button" onClick={() => { handleButtonClick(); handleContext(); }}>
    Login
</button>
                </form>
            </div>
        </div>
        </>
    );
};


export default Login;