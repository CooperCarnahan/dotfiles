import React, { Children, useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import * as zebar from "zebar";
import MediaPlayerWidget from "./components/MediaPlayerWidget.jsx";
import Settings from "./components/Settings.jsx";
import ActiveApp from "./components/ActiveApp.jsx";
import moment from "moment";

const providers = zebar.createProviderGroup({
  keyboard: { type: "keyboard" },
  glazewm: { type: "glazewm" },
  cpu: { type: "cpu" },
  date: { type: "date", formatting: "EEE d MMM t" },
  battery: { type: "battery" },
  memory: { type: "memory" },
  weather: { type: "weather" },
  host: { type: "host" },
  media: { type: "media" },
});

createRoot(document.getElementById("root")).render(<App />);

function App() {
  const [output, setOutput] = useState(providers.outputMap);
  const [showMediaWidget, setShowMediaWidget] = useState(true);
  const [ShowActiveApp, setShowActiveApp] = useState(true);
  const [dateFormat, setDateFormat] = useState("hh:mm A"); // Updated to 12-hour AM/PM

  useEffect(() => {
    providers.onOutput(() => setOutput(providers.outputMap));
  }, []);

  function getBatteryIcon(batteryOutput) {
    let iconClass = "nf ";
    let color = "";
    if (batteryOutput.chargePercent > 90) {
      iconClass += "nf-fa-battery_4";
      color = "#4caf50"; // green
    } else if (batteryOutput.chargePercent > 70) {
      iconClass += "nf-fa-battery_3";
      color = "#4caf50"; // green
    } else if (batteryOutput.chargePercent > 40) {
      iconClass += "nf-fa-battery_2";
      color = "#ffeb3b"; // yellow
    } else if (batteryOutput.chargePercent > 20) {
      iconClass += "nf-fa-battery_1";
      color = "#ffeb3b"; // yellow
    } else {
      iconClass += "nf-fa-battery_0";
      color = "#e53935"; // red
    }
    return <i className={iconClass} style={{ color }}></i>;
  }

  function getWeatherIcon(weatherOutput) {
    let iconClass = "nf ";
    let color = "";
    switch (weatherOutput.status) {
      case "clear_day":
        iconClass += "nf-weather-day_sunny";
        color = "#FFD600"; // yellow
        break;
      case "clear_night":
        iconClass += "nf-weather-night_clear";
        color = "#FFD600"; // yellow
        break;
      case "cloudy_day":
        iconClass += "nf-weather-day_cloudy";
        color = "#B0BEC5"; // grey
        break;
      case "cloudy_night":
        iconClass += "nf-weather-night_alt_cloudy";
        color = "#B0BEC5"; // grey
        break;
      case "light_rain_day":
        iconClass += "nf-weather-day_sprinkle";
        color = "#2196F3"; // blue
        break;
      case "light_rain_night":
        iconClass += "nf-weather-night_alt_sprinkle";
        color = "#2196F3"; // blue
        break;
      case "heavy_rain_day":
        iconClass += "nf-weather-day_rain";
        color = "#1976D2"; // darker blue
        break;
      case "heavy_rain_night":
        iconClass += "nf-weather-night_alt_rain";
        color = "#1976D2"; // darker blue
        break;
      case "snow_day":
        iconClass += "nf-weather-day_snow";
        color = "#FFFFFF"; // white
        break;
      case "snow_night":
        iconClass += "nf-weather-night_alt_snow";
        color = "#FFFFFF"; // white
        break;
      case "thunder_day":
        iconClass += "nf-weather-day_lightning";
        color = "#FFD600"; // yellow
        break;
      case "thunder_night":
        iconClass += "nf-weather-night_alt_lightning";
        color = "#FFD600"; // yellow
        break;
      default: // Handle unknown status gracefully
        iconClass += "nf-weather-na";
        color = "#B0BEC5"; // grey
        break;
    }
    return <i className={iconClass} style={{ color }}></i>;
  }

  function getMemoryIcon(memoryOutput) {
    let iconClass = "nf nf-fae-chip";
    let color = "#888888";
    if (memoryOutput.usage > 85) {
      color = "#e53935"; // red
    } else if (memoryOutput.usage > 60) {
      color = "#ffeb3b"; // yellow
    }
    return <i className={iconClass} style={{ color }}></i>;
  }

  function getCpuIcon(cpuOutput) {
    let iconClass = "nf nf-oct-cpu";
    let color = "#888888";
    if (cpuOutput.usage > 85) {
      color = "#e53935"; // red
    } else if (cpuOutput.usage > 60) {
      color = "#ffeb3b"; // yellow
    }
    return <i className={iconClass} style={{ color }}></i>;
  }

  // debug
  console.log(output.glazewm);

  return (
    <div className="app">
      <div className="left">
        <div className="box">
          <div className="logo">
            <span
              style={{
                display: "inline-flex",
                alignItems: "center",
                height: "1em",
                marginRight: "0.2em",
              }}
            >
              <svg width="22" height="22" viewBox="0 0 48 48" fill="none">
                <rect
                  x="4"
                  y="4"
                  width="18"
                  height="18"
                  rx="2"
                  fill="#00ADEF"
                />
                <rect
                  x="26"
                  y="4"
                  width="18"
                  height="18"
                  rx="2"
                  fill="#00ADEF"
                />
                <rect
                  x="4"
                  y="26"
                  width="18"
                  height="18"
                  rx="2"
                  fill="#00ADEF"
                />
                <rect
                  x="26"
                  y="26"
                  width="18"
                  height="18"
                  rx="2"
                  fill="#00ADEF"
                />
                <rect
                  x="23"
                  y="4"
                  width="2"
                  height="40"
                  fill="#fff"
                  opacity="0.15"
                />
                <rect
                  x="4"
                  y="23"
                  width="40"
                  height="2"
                  fill="#fff"
                  opacity="0.15"
                />
              </svg>
            </span>
            {output.host?.hostname}
          </div>
          <div className="separator" />
          {output.glazewm && (
            <div className="workspaces">
              {output.glazewm.currentWorkspaces.map((workspace) => (
                <button
                  className={`workspace ${workspace.hasFocus && "focused"} ${workspace.isDisplayed && "displayed"}`}
                  onClick={() =>
                    output.glazewm.runCommand(
                      `focus --workspace ${workspace.name}`,
                    )
                  }
                  key={workspace.name}
                >
                  {workspace.displayName ?? workspace.name}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      <div className="center">
        <div className="box">
          {showMediaWidget && output.media ? (
            <MediaPlayerWidget mediaOutput={output.media} />
          ) : null}
          <i className="nf nf-md-calendar_month"></i>
          <button
            className="clean-button"
            onMouseEnter={() => {
              setDateFormat("ddd DD MMM hh:mm A"); // 12-hour AM/PM
            }}
            onMouseLeave={() => {
              setDateFormat("hh:mm A"); // 12-hour AM/PM
            }}
          >
            {moment(output.date?.now).format(dateFormat)}
          </button>
          {ShowActiveApp && output.glazewm ? (
            <ActiveApp output={output} />
          ) : null}
        </div>
      </div>

      <div className="right">
        <div className="box">
          {output.glazewm && (
            <>
              {output.glazewm.bindingModes.map((bindingMode) => (
                <button className="binding-mode" key={bindingMode.name}>
                  {bindingMode.displayName ?? bindingMode.name}
                </button>
              ))}

              <button
                className={`tiling-direction nf ${output.glazewm.tilingDirection === "horizontal" ? "nf-md-swap_horizontal" : "nf-md-swap_vertical"}`}
                onClick={() =>
                  output.glazewm.runCommand("toggle-tiling-direction")
                }
              ></button>
            </>
          )}

          <Settings
            widgetObj={[
              { name: "Media", changeState: setShowMediaWidget }, // Still controls visibility of the media player
              { name: "App", changeState: setShowActiveApp },
            ]}
            output={output}
            additionalContent={
              <>
                {/* memory */}
                {output.memory && (
                  <button
                    className="memory clean-button"
                    onClick={() =>
                      output.glazewm.runCommand("shell-exec taskmgr")
                    }
                  >
                    {getMemoryIcon(output.memory)}
                    {Math.round(output.memory.usage)}%
                  </button>
                )}

                {/* cpu */}
                {output.cpu && (
                  <button
                    className="cpu clean-button"
                    onClick={() =>
                      output.glazewm.runCommand("shell-exec taskmgr")
                    }
                  >
                    {getCpuIcon(output.cpu)}
                    {/* Change the text color if the CPU usage is high. */}
                    <span className={output.cpu.usage > 85 ? "high-usage" : ""}>
                      {Math.round(output.cpu.usage)}%
                    </span>
                  </button>
                )}

                {/* battery */}
                {output.battery && (
                  <div className="battery">
                    {output.battery.isCharging && (
                      <i className="nf nf-md-power_plug charging-icon"></i>
                    )}
                    {getBatteryIcon(output.battery)}
                    {Math.round(output.battery.chargePercent)}%
                  </div>
                )}

                {/* weather */}
                {output.weather && (
                  <div className="weather">
                    {getWeatherIcon(output.weather)}
                    {Math.round(output.weather.fahrenheitTemp)}°F
                  </div>
                )}
              </>
            }
          />
        </div>
      </div>
    </div>
  );
}
