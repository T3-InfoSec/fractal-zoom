import {Canvas} from "@react-three/fiber";
import {BurningShipThreeMesh} from "./BurningShipThreeMesh.tsx";
import React from "react";

interface ILocalProps {
 updatePosition: (position: {x: number, y: number}) => void;
 reset: boolean;
 maxIterations: number;
 colorScheme: number;
 fractal: string;
 zoom: number;
}

const BurningShip: React.FC<ILocalProps> = ({updatePosition, reset, maxIterations, colorScheme, fractal ,zoom}) => {
    return (
        <Canvas
            camera={{
                fov: 10
            }}>
            <ambientLight />
                <BurningShipThreeMesh
                    updatePosition={updatePosition}
                    maxIterations={maxIterations}
                    colorScheme={colorScheme}
                    fractal={fractal}
                    zoom={zoom}
                    reset={reset} />

        </Canvas>
    );
};

export default BurningShip;