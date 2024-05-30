import { child, get, ref, remove } from "firebase/database";
import React, { useEffect, useState } from 'react';
import { BiXCircle } from "react-icons/bi";
import { Link } from 'react-router-dom';
import { database } from '../firebaseConfig';
import './ExploreContainer.css';
import Menu from './Menu';
import './MenuComp.css';
import MyContext from './MyContext';

const HomeTra: React.FC = () => {
  const { myVariable, setMyVariable } = React.useContext(MyContext);
  const [usuarios, setUsuarios] = useState<any[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async (path: string) => {
      const dbRef = ref(database);
      try {
        const snapshot = await get(child(dbRef, path));
        if (snapshot.exists()) {
          console.log('Data fetched:', snapshot.val());
          setUsuarios(
            Object.entries(snapshot.val()).map(([key, value]) => {
              if (typeof value === 'object' && value !== null) {
                return { ...value, id: key };
              }
              return { id: key };
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

    fetchData('/clave');
  }, []);

  const deleteData = async (id: string) => {
    const dbRef = ref(database, `/clave/${id}`);
    try {
      await remove(dbRef);
      console.log('Data removed successfully');
      // Update the state after deletion
      setUsuarios((prevUsuarios) => prevUsuarios.filter((clave) => clave.id !== id));
    } catch (error) {
      console.error("Error removing data:", error);
      setError("Error removing data");
    }
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <>
    <div id="containerLog">
      <Link to="/home">
        <div id='logout'>Cerrar Sesión</div>
      </Link>
      <p id='titulo'>Claves</p>
      <div id='tres-claves'>
        <div id='cuadros-tres-claves'>
          <p>Libres</p>
        </div>
        <div id='cuadros-tres-claves'>
          <p>Ocupados</p>
        </div>
        <div id='cuadros-tres-claves'>
          <p>Utilizados</p>
        </div>
      </div>

      <div id='tres-claves-basso'>
        <div id='cuadros-tres-claves-basso'>
          <p id="libr-ocup-util">Libres</p>
          {usuarios.filter(clave => clave.estatus === 'libre').sort((a, b) => {
            const aHasFe = a.usuario.includes(myVariable);
            const bHasFe = b.usuario.includes(myVariable);

            if (aHasFe && !bHasFe) {
              return -1; 
            } else if (!aHasFe && bHasFe) {
              return 1; 
            } else {
              return 0; // no change
            }
          }).map((clave, index) => (
            <div key={clave.id} id='text-row'>
              <p id='num-titulo'>{clave.numero}.</p>
              <div id='text-between'>
                <p>Usuario de la clave:</p>
                <p id='usr-titulo'>{clave.usuario}</p>
              </div>
              <BiXCircle id={clave.usuario == myVariable ? 'tache' : 'tache-no'} onClick={() => deleteData(clave.id)} />
            </div>
          ))}
        </div>
        <div id='cuadros-tres-claves-basso'>
        <p id="libr-ocup-util">Ocupados</p>
        {usuarios.filter(clave => clave.estatus === 'ocupado').sort((a, b) => {
            const aHasFe = a.usuario.includes(myVariable);
            const bHasFe = b.usuario.includes(myVariable);

            if (aHasFe && !bHasFe) {
              return -1; 
            } else if (!aHasFe && bHasFe) {
              return 1; 
            } else {
              return 0; // no change
            }
          }).map((clave, index) => (
            <div key={clave.id} id='text-row'>
              <p id='num-titulo'>{clave.numero}.</p>
              <div id='text-between'>
                <p>Usuario de la clave:</p>
                <p id='usr-titulo'>{clave.usuario}</p>
              </div>
              <BiXCircle id={clave.usuario == myVariable ? 'tache' : 'tache-no'} onClick={() => deleteData(clave.id)} />
            </div>
          ))}
        </div>
        <div id='cuadros-tres-claves-basso'>
        <p id="libr-ocup-util">Utilizados</p>
        {usuarios.filter(clave => clave.estatus === 'utilizado').sort((a, b) => {
            const aHasFe = a.usuario.includes(myVariable);
            const bHasFe = b.usuario.includes(myVariable);

            if (aHasFe && !bHasFe) {
              return -1; 
            } else if (!aHasFe && bHasFe) {
              return 1; 
            } else {
              return 0; // no change
            }
          }).map((clave, index) => (
            <div key={clave.id} id='text-row'>
              <p id='num-titulo'>{clave.numero}.</p>
              <div id='text-between'>
                <p>Usuario de la clave:</p>
                <p id='usr-titulo'>{clave.usuario}</p>
              </div>
              <BiXCircle id={clave.usuario == myVariable ? 'tache' : 'tache-no'} onClick={() => deleteData(clave.id)} />
            </div>
          ))}
        </div>
      </div>
      <Menu/>
    </div>
    </>
  );
};

export default HomeTra;
