import type { Plugin } from "@opencode-ai/plugin";

/**
 * Apprise Notification Plugin for OpenCode
 * 
 * Provides a 'notify' tool that allows AI agents to send notifications
 * via the Apprise CLI when long-running tasks or sessions complete.
 * 
 * Uses the existing Apprise installation and configuration files.
 */
export default (async (ctx) => {
    return {
        tool: {
            notify: {
                description: "Send a notification using Apprise. Use this to notify the user when long-running tasks complete, sessions finish, or important milestones are reached.",
                parameters: {
                    type: "object",
                    properties: {
                        title: {
                            type: "string",
                            description: "The notification title (required)",
                        },
                        body: {
                            type: "string",
                            description: "The notification message body (optional)",
                        },
                    },
                    required: ["title"],
                },
                execute: async ({ title, body }) => {
                    try {
                        // Build the apprise command
                        const args = ["-t", title];
                        
                        if (body) {
                            args.push("-b", body);
                        }
                        
                        // Execute apprise CLI using BunShell
                        const result = await ctx.$`apprise ${args}`.quiet();
                        
                        // Check if the command succeeded
                        if (result.exitCode === 0) {
                            return {
                                success: true,
                                message: `Notification sent: "${title}"`,
                            };
                        } else {
                            return {
                                success: false,
                                message: `Failed to send notification. Exit code: ${result.exitCode}`,
                                stderr: result.stderr?.toString(),
                            };
                        }
                    } catch (error) {
                        // Handle any errors gracefully
                        return {
                            success: false,
                            message: `Error sending notification: ${error instanceof Error ? error.message : String(error)}`,
                        };
                    }
                },
            },
        },
    };
}) satisfies Plugin;
