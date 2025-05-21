import React, { useEffect, useState } from 'react';
import { createRoot } from 'react-dom/client';
import * as zebar from 'zebar';

// We only need the glazewm provider for workspaces
const providers = zebar.createProviderGroup({
    glazewm: { type: 'glazewm' },
});

createRoot(document.getElementById('root')).render(<App />);

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
                        {/* Static Windows icon as host data is no longer provided */}
                        <i className="nf nf-custom-windows"></i>
                        {/* Hostname removed as host provider is no longer included
                            You could hardcode a title here if desired, e.g., "Workspaces" */}
                    </div>
                    {output.glazewm && (
                        <div className="workspaces">
                            {output.glazewm.currentWorkspaces.map(workspace => (
                                <button
                                    className={`workspace ${workspace.hasFocus ? 'focused' : ''} ${workspace.isDisplayed ? 'displayed' : ''}`}
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
