import { Vector2 } from "three";


export const getWindowSize = () => {
  return new Vector2(window.innerWidth * window.devicePixelRatio, window.innerHeight * window.devicePixelRatio);
};

export const getAspectRatio = () => {

  const windowSize = getWindowSize();
  return windowSize.x / windowSize.y;
};

export const getDefaultUniforms = (startZoom: number) => {

  return {

    u_resolution: {
      value: getWindowSize(),
    },
    u_aspectRatio: {
      value: getAspectRatio()
    },
    u_zoomSize: {
      value: startZoom,
    },
    u_offset: {
      value: new Vector2(-(startZoom / 2) * getAspectRatio(), -(startZoom / 2)),
    },
    u_maxIterations: {
      value: 200,
    },
    u_color_scheme: {
        value: 2,
    }
  }
};
