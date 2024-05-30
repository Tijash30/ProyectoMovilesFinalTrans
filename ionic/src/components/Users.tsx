import { child, get, ref, set } from "firebase/database";
import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { v4 as uuidv4 } from 'uuid';
import { database } from '../firebaseConfig';
import './ExploreContainer.css';
import Menu from './Menu';

interface ContainerProps { }

const Users: React.FC<ContainerProps> = () => {

    const [usuarios, setUsuarios] = useState<any[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);
    const [email, setEmail] = useState<string | null>(null);
    const [password, setPassword] = useState<string | null>(null);
    const [carrera, setCarrera] = useState<string | null>(null);
    const [semestre, setSemestre] = useState<string | null>(null);
    const [nombre, setNombre] = useState('');
    const [apellido, setApellido] = useState('');

    const fetchData = async () => {
        const dbRef = ref(database);
        const snapshot = await get(child(dbRef, '/usuarios'));
        const data = snapshot.val();
        try {
            if (snapshot.exists()) {
                console.log('Data fetched:', snapshot.val());
                setUsuarios(
                    Object.entries(snapshot.val()).map(([key, value]) => {
                    if (typeof value === 'object' && value !== null) {
                        return { ...value, id: key };
                    }
                    return { id: key }; // or handle non-object values as needed
                    })
                );
            } else {
            console.log("No data available");
            }
        } catch (error) {
            console.error("Error getting data:", error);
            setError("Error getting data");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);


  const writeDataWithSet = async () => {
    try {
        const newKey = uuidv4();
        await set(ref(database, '/usuarios/'+newKey), {
            email: email,
            password: password,
            nombre: nombre,
            apellido: apellido,
            carrera: carrera,
            semestre: semestre,
        });
        console.log("Data written successfully");
        fetchData(); // Reload data
    } catch (error) {
        console.error("Error writing data: ", error);
    }
};


    return (
        <div id="containerLog">
            <Link to="/home">
        <div id='logout'>Cerrar Sesión</div>
      </Link>
            <Menu/>
            <p id='titulo'>Usuarios</p>
            <div id='dos-partes'>
                <div id='wrapper'>
                    {usuarios.map((clave, index) => (
                        <div key={index} id='div-wraaa' >
                            <div id="text-between-wra">
                                <p id='num-titulo'>{clave.nombre} {clave.apellido}</p>
                                <p id="email-wra">{clave.email}</p>
                            </div>
                            <div id='text-carrera'>
                                <p id="text-basso">{clave.carrera} {clave.semestre} {clave.semestre!= null ? 'semestre' : ''}</p>
                            </div>
                        </div>
                    ))}
                </div>
                {/*<div>
                    <h2>Add New Entry</h2>
                    <form onSubmit={handleSubmit}>
                        <div>
                            <label>Name: </label>
                            <input
                            type="text"
                            name="name"
                            onChange={(e) => setNombre(e.target.value)}
                            required
                            />
                        </div>
                        <div>
                            <label>Apellido: </label>
                            <input
                            type="text"
                            name="favoriteColor"
                            onChange={(e) => setApellido(e.target.value)}
                            required
                            />
                        </div>
                        <div>
                            <label>email </label>
                            <input
                            type="text"
                            name="lastName"
                            onChange={(e) => setEmail(e.target.value)}
                            required
                            />
                        </div>
                        <div>
                            <label>pass </label>
                            <input
                            type="text"
                            name="favoriteAnimal"
                            required
                            onChange={(e) => setPassword(e.target.value)}
                            />
                        </div>
                        <div>
                            <label>carrera </label>
                            <input
                            type="text"
                            name="lastName"
                            onChange={(e) => setCarrera(e.target.value)}
                            required
                            />
                        </div>
                        <div>
                            <label>semes </label>
                            <input
                            type="text"
                            name="favoriteAnimal"
                            required
                            onChange={(e) => setSemestre(e.target.value)}
                            />
                        </div>
                        <button type="submit" onClick={() => {  writeDataWithSet(); }}>Submit</button>
                    </form>
                </div>*/}
            </div>
            
        </div>
    );
};

export default Users;