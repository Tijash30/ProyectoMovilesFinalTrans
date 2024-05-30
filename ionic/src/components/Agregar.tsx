import firebase from 'firebase/compat/app';
import { child, get, ref, set } from "firebase/database";
import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { auth, database, } from '../firebaseConfig';
import './ExploreContainer.css';
import Menu from './Menu';
import MyContext from './MyContext';

interface ContainerProps { }


const Agregar: React.FC<ContainerProps> = () => {


    const { myVariable, setMyVariable } = React.useContext(MyContext);

    const [user, setUser] = useState<firebase.User | null>(null);

    useEffect(() => {
        const unsubscribe = auth.onAuthStateChanged((user) => {
            if (user) {
                setUser(user);
                console.log(user);
            } else {
                setUser(null);
            }
        });

    // Cleanup subscription on unmount
        return () => unsubscribe();
    }, []);


    const [elementCount, setElementCount] = useState(0);
    const [maxNumber, setMaxNumber] = useState(0);
    const fetchData = async () => {
        const dbRef = ref(database);
        const snapshot = await get(child(dbRef, '/clave'));
        const data = snapshot.val();
    
        if (data) {
            const count = Object.keys(data).length;
            setElementCount(count);
    
            // Normalize data to be an array of objects
            const dataArray = Array.isArray(data) ? data : Object.values(data);
    
            const numbers = dataArray
                .filter(item => item && typeof item === 'object' && 'numero' in item)
                .map(item => item.numero);
    
            const maxNumber = numbers.length > 0 ? Math.max(...numbers) : 0;
            setMaxNumber(maxNumber);
            console.log('maxime  ' + maxNumber);
        } else {
            setElementCount(0);
            setMaxNumber(0);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);


    const [data, setData] = useState("");

    const writeDataWithSet = async () => {
        let countclaves= maxNumber+1;
        try {
            await set(ref(database, '/clave/'+countclaves), {
                estatus: "libre",
                numero: countclaves,
                usuario: myVariable,
            });
            console.log("Data written successfully");
            fetchData(); // Reload data
            handleclicktre(); // Show confirmation
        } catch (error) {
            console.error("Error writing data: ", error);
        }
    };


    const [clickedtre, setClickedtre]= useState(false);
    const handleclicktre = () => {
        setClickedtre(!clickedtre);
    }

    return (
        <>
        <div id="containerLog">
        <Link to="/home">
        <div id='logout'>Cerrar Sesión</div>
      </Link>
            <p id='titulo'>Agregar Claves</p>
            {user ? (
                <div id='agregar-textos'>
                        <div id='text-between'>
                            <p >Email con el que se registrará   la clave: </p>
                            <p>{myVariable}</p>
                        </div>
                        <div id='text-between'>
                            <p >Número de claves existentes:</p>
                            <p>  {elementCount}</p>
                        </div>
                        <button id='boton-clave' onClick={() => {  writeDataWithSet(); }}>Agregar</button>
                </div>
            ) : (
                    <h1>No user is logged in</h1>
            )}
            <Menu/>
        </div>
        <div id={ clickedtre ? 'confirm-con-active' : 'confirm-con ' } >
            <div id='confirm--container'>
                <p>Clave agregada con éxito</p>
                <button onClick={() => handleclicktre()}>Cerrar</button>
            </div>
        </div>
        </>
    );
  
};

export default Agregar;