// MyContext.tsx
import React from 'react';

interface ContextProps {
  myVariable: string;
  setMyVariable: React.Dispatch<React.SetStateAction<string>>;
}

const MyContext = React.createContext<ContextProps>({
  myVariable: '',
  setMyVariable: () => {},
});

interface MyContextProviderProps {
  children: React.ReactNode;
}

export const MyContextProvider: React.FC<MyContextProviderProps> = ({ children }) => {
  const [myVariable, setMyVariable] = React.useState<string>('Hello, World!');

  return (
    <MyContext.Provider value={{ myVariable, setMyVariable }}>
      {children}
    </MyContext.Provider>
  );
};

export default MyContext;
