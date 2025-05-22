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
    if (batteryOutput.chargePercent > 90)
      return <i className="nf nf-fa-battery_4"></i>;
    if (batteryOutput.chargePercent > 70)
      return <i className="nf nf-fa-battery_3"></i>;
    if (batteryOutput.chargePercent > 40)
      return <i className="nf nf-fa-battery_2"></i>;
    if (batteryOutput.chargePercent > 20)
      return <i className="nf nf-fa-battery_1"></i>;
    return <i className="nf nf-fa-battery_0"></i>;
  }

  function getWeatherIcon(weatherOutput) {
    switch (weatherOutput.status) {
      case "clear_day":
        return <i className="nf nf-weather-day_sunny"></i>;
      case "clear_night":
        return <i className="nf nf-weather-night_clear"></i>;
      case "cloudy_day":
        return <i className="nf nf-weather-day_cloudy"></i>;
      case "cloudy_night":
        return <i className="nf nf-weather-night_alt_cloudy"></i>;
      case "light_rain_day":
        return <i className="nf nf-weather-day_sprinkle"></i>;
      case "light_rain_night":
        return <i className="nf nf-weather-night_alt_sprinkle"></i>;
      case "heavy_rain_day":
        return <i className="nf nf-weather-day_rain"></i>;
      case "heavy_rain_night":
        return <i className="nf nf-weather-night_alt_rain"></i>;
      case "snow_day":
        return <i className="nf nf-weather-day_snow"></i>;
      case "snow_night":
        return <i className="nf nf-weather-night_alt_snow"></i>;
      case "thunder_day":
        return <i className="nf nf-weather-day_lightning"></i>;
      case "thunder_night":
        return <i className="nf nf-weather-night_alt_lightning"></i>;
      default: // Handle unknown status gracefully
        return <i className="nf nf-weather-na"></i>; // "Not Available" icon
    }
  }

  // debug
  console.log(output.glazewm);

  return (
    <div className="app">
      <div className="left">
        <div className="box">
          <div className="logo">
            <i className="nf nf-custom-windows"></i>
            {output.host?.hostname} |
          </div>
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
                    <i className="nf nf-fae-chip"></i>
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
                    <i className="nf nf-oct-cpu"></i>

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
