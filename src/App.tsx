import './App.css'
import BurningShip from "./Components/BurningShip/BurningShip.tsx";
import Controls from "./Components/Controls/Controls.tsx";
import {useEffect, useState} from "react";
function App() {
    const [position, setPosition] = useState({x: 0, y: 0});
    const [reset, setReset] = useState(false);
    const [maxIterations, setMaxIterations] = useState(100);
    const [colorScheme, setColorScheme] = useState(1);
    const [fractal, setFractal] = useState('mandelbrot');
    const [zoom, setZoom] = useState(2.0);
    const updatePosition = (position: {x: number, y: number}) => {
        setPosition(position);
    }

    useEffect(() => {
        window._flutterMessages = [];

        window.sendToFlutter = function(message: string) {
            window._flutterMessages.push(JSON.stringify(message));
            console.log('Message added to buffer:', message);
        };

        window.getFlutterMessages = function() {
            const messages = window._flutterMessages;
            window._flutterMessages = [];
            return JSON.stringify(messages);
        };

        window.receiveFromFlutter = function(message: string) {
            const event = new CustomEvent('flutterMessage', {
                detail: JSON.parse(message)
            });
            window.dispatchEvent(event);
            console.log('Received from Flutter:', message);
        };
    }, []);

  return (
    <>
        <BurningShip updatePosition={updatePosition}
                     reset={reset}
                     maxIterations={maxIterations}
                     fractal={fractal}
                     zoom={zoom}
                     colorScheme={colorScheme}/>
        <Controls position={position}
                  setReset={setReset}
                  setMaxIterations={setMaxIterations}
                  setFractal={setFractal}
                  fractal={fractal}
                  zoom={zoom}
                  setZoom={setZoom}
                  maxIterations={maxIterations}
                  colorScheme={colorScheme}
                  setColorScheme={setColorScheme}/>
    </>
  )
}

export default App
