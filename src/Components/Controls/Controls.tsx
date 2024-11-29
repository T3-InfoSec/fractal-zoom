import React, {useEffect} from "react";
import './Controls.css'
import {
    Button,
    FormControl,
    InputLabel,
    MenuItem,
    Select,
    SelectChangeEvent, Slider,
    TextField,
    Typography
} from "@mui/material";


interface ILocalProps {
    position: {x: number, y: number};
    setReset: (reset: boolean) => void;
    setMaxIterations: (maxIterations: number) => void;
    maxIterations: number;
    colorScheme: number;
    setColorScheme: (colorScheme: number) => void;
    setFractal: (fractal: string) => void;
    fractal: string;
    zoom: number;
    setZoom: (zoom: number) => void;
    setSave: (save: boolean) => void;
}

const Controls: React.FC<ILocalProps> = ({position, setReset, maxIterations, setMaxIterations, setColorScheme, colorScheme, zoom, setZoom, setSave}) => {

    const [zoomFactor, setZoomFactor] = React.useState<number>(2);
    const [exponent, setExponent] = React.useState({real: 1, imaginary: 0});

    useEffect(() => {
        window.addEventListener('flutterMessage', (event: any) => {
            const message = event.detail;
            console.log('Received message from Flutter:', message);
            if (message.type === 'position') {
                setExponent(message.payload);
            }
        });

        return () => {
            window.removeEventListener('flutterMessage', () => {});
        }
    },[]);


    const handleResetOn = () => {
        console.log("Resetting");
        setReset(true);
        setColorScheme(1);
        setMaxIterations(100);
        setZoom(2.0);
    };

    const handleResetOff = () => {
        setReset(false);
    }

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        try {
            console.log(e.target.value);
            if(e.target.value === '') {
                setMaxIterations(0);
                return;
            }
            setMaxIterations(parseInt(e.target.value));
        } catch (e) {
            console.log(e);
            setMaxIterations(1000);
        }
    }

    const handleZoom = (zoomIn: boolean) => {
        if(zoomIn) {
            console.log(zoom);
            console.log((1 - (zoomFactor / 100)));
            setZoom(zoom * (1 - (zoomFactor / 100)));
            console.log(zoomFactor);
            console.log(zoom);
        } else {
            setZoom(zoom * (1 + (zoomFactor / 100)));
            console.log(zoomFactor);
            console.log(zoom);

        }
    }

    const submitSelected = () => {
        window.sendToFlutter(JSON.stringify({type: 'position', payload: position}));
    }
    const handleSelectChange = (e: SelectChangeEvent) => {
        setColorScheme(parseInt(e.target.value));
    }

    const handleSaveOn = () => {
        setSave(true);

    }

    const handleSaveOff = () => {
        setSave(false);
    }

    // const handleFractalChange = (e: SelectChangeEvent) => {
    //     setFractal(e.target.value);
    // }

    return (
        <div id={'controls-container'}>
            <button onMouseDown={handleResetOn} onMouseUp={handleResetOff}>Reset</button>
            <Typography>Use Q+mouse button to zoom in</Typography>
            <Typography>Use A+mouse button to zoom out</Typography>
            <p>Real part: {position.x}</p>
            <p>Imaginary Part: {position.y}</p>
            <p>Exponent Real: {exponent.real}</p>
            <p>Exponent Imag: {exponent.imaginary}</p>
            <TextField sx={{margin: '10px'}} id="iterations-text" label="Max Iterations" variant="outlined"
                       value={maxIterations} onChange={handleChange}/>
            <FormControl sx={{margin: '10px'}}>
                <InputLabel id="simple-color-scheme">Color Scheme</InputLabel>
                <Select
                    labelId="demo-simple-select-label"
                    id="demo-simple-select"
                    value={colorScheme.toString()}
                    label="Color Scheme"
                    onChange={handleSelectChange}
                >
                    {[1, 2, 3, 4, 5].map((value) => (
                        <MenuItem value={value} key={value}>{value}</MenuItem>
                    ))}

                </Select>
            </FormControl>
            <Typography>Zoom Factor</Typography>
            <Slider
                aria-label="Zoom Factor"
                defaultValue={30}
                value={zoomFactor}
                onChange={(_e, value) => setZoomFactor(value as number)}
                valueLabelDisplay="auto"
                shiftStep={10}
                step={10}
                marks
                min={10}
                max={90}
            />

            <Button onClick={() => {
                handleZoom(true)
            }}>Zoom In</Button>
            <Button onClick={() => {
                handleZoom(false)
            }}>Zoom Out</Button>
            <Button onClick={submitSelected}>Submit</Button>
            <button onMouseDown={handleSaveOn} onMouseUp={handleSaveOff}>Save</button>

        </div>
    );
};

export default Controls;