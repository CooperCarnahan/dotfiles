import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import * as zebar from "zebar";

// We only need the glazewm provider for workspaces
const providers = zebar.createProviderGroup({
  glazewm: { type: "glazewm" },
});

createRoot(document.getElementById("root")).render(<App />);

function App() {
  const [output, setOutput] = useState(providers.outputMap);

  useEffect(() => {
    // Listen for updates from the glazewm provider
    providers.onOutput(() => setOutput(providers.outputMap));
  }, []);

  // debug (optional, can be removed)
  console.log(output.glazewm);

  return (
    <div className="app">
      <div className="left">
        <div className="box">
          <div className="logo">
            {/* Windows 11 logo SVG */}
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
          </div>
          {output.glazewm && (
            <div className="workspaces">
              {output.glazewm.currentWorkspaces.map((workspace) => (
                <button
                  className={`workspace ${workspace.hasFocus ? "focused" : ""} ${workspace.isDisplayed ? "displayed" : ""}`}
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

      {/* The 'center' and 'right' divs are removed entirely */}
      {/* If you have CSS that expects these, you might need to adjust your styling */}
    </div>
  );
}

export default App; // Export App if it's imported elsewhere, otherwise it's just for createRoot
