import { IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from '@ionic/react';
import './Home.css';
import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Login from '../components/Login';
import HomeTra from '../components/HomeTra';
import Users from '../components/Users';
import Agregar from '../components/Agregar';

const Home: React.FC = () => {
  return (
    <Router>
        <Switch>
            <Route path="/home" exact component={Login} />
            <Route path='/users' component={Users} />
            <Route path='/agregar' component={Agregar} />
            {<Route path="/principal" component={HomeTra} />}
        </Switch>
    </Router>
  );
};

export default Home;
