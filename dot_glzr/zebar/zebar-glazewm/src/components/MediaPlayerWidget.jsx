// MediaPlayerWidget.jsx
import React, { useEffect, useState } from 'react';

/**
 * @typedef {import('../create-base-provider').Provider} Provider
 * @typedef {import('./types').MediaOutput} MediaOutput
 * @typedef {import('./types').MediaSession} MediaSession
 */

/**
 * MediaPlayerWidget component displays the current media session and provides controls.
 * It uses the generic MediaOutput interface.
 * @param {object} props
 * @param {MediaOutput} props.mediaOutput - The output from the media provider.
 */
const MediaPlayerWidget = ({ mediaOutput }) => {
    // State to hold the current song/media title
    const [mediaTitle, setMediaTitle] = useState('No media playing');
    // State to control the visibility of media controls
    const [showControls, setShowControls] = useState(false);

    // Determine max length for the media title based on window width
    // This is a common pattern for responsive truncation.
    const maxTitleLength = window.innerWidth > 1600 ? 30 : 10;

    // Effect to update the media title whenever mediaOutput.currentSession changes
    useEffect(() => {
        if (mediaOutput && mediaOutput.currentSession) {
            // If there's a current session, display its title
            setMediaTitle(mediaOutput.currentSession.title || 'Unknown Title');
        } else {
            // If no current session, display a default message
            setMediaTitle('No media playing');
        }
    }, [mediaOutput]); // Re-run effect when mediaOutput changes

    // Style for the main button/link container
    const buttonStyle = {
        textDecoration: 'none',
        color: 'var(--font-color)',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
    };

    // Style for the media controls container
    const controlsStyle = {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        gap: '5px',
        paddingRight: '10px',
    };

    // Style for individual control icons (play/pause, next, previous)
    const iconStyle = {
        cursor: 'pointer',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        color: 'var(--font-color)',
        borderRadius: '50%',
    };

    // Determine if controls should be shown (based on hover and media playing status)
    const canShowControls = showControls && mediaOutput && mediaOutput.currentSession;

    return (
        <button
            className="clean-button"
            onMouseEnter={() => setShowControls(true)}
            onMouseLeave={() => setShowControls(false)}
            style={buttonStyle}
        >
            {/* Main media player link/display area */}
            <a className="logo" href="spotify:home" target="_blank" style={buttonStyle}>
                {/* Generic music icon */}
                <i className="nf nf-md-music_box" style={{ color: 'var(--main-color)' }}></i>
                {/* Truncate media title if too long */}
                {mediaTitle.length > maxTitleLength ? mediaTitle.substring(0, maxTitleLength) + '...' : mediaTitle}
            </a>

            {/* Media controls (play/pause, next, previous) */}
            {canShowControls ? (
                <div style={controlsStyle}>
                    {/* Previous Song Button */}
                    <button
                        className="nf nf-md-skip_previous clean-button"
                        style={iconStyle}
                        onClick={async () => {
                            // Call the previous method from mediaOutput
                            mediaOutput.previous();
                            // Optional: Add a small delay before updating to allow action to register
                            // For a generic media player, we might not need to re-fetch as the provider
                            // should update the output automatically.
                        }}
                    ></button>

                    {/* Play/Pause Toggle Button */}
                    <button
                        className={`nf ${mediaOutput.currentSession?.isPlaying ? 'nf-md-pause' : 'nf-md-play' } clean-button`}
                        style={iconStyle}
                        onClick={async () => {
                            // Call the togglePlayPause method from mediaOutput
                            mediaOutput.togglePlayPause();
                        }}
                    ></button>

                    {/* Next Song Button */}
                    <button
                        className="nf nf-md-skip_next clean-button"
                        style={iconStyle}
                        onClick={async () => {
                            // Call the next method from mediaOutput
                            mediaOutput.next();
                        }}
                    ></button>
                </div>
            ) : null}
        </button>
    );
};

export default MediaPlayerWidget;
