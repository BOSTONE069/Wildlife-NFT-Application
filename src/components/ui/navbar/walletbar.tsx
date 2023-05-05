/* `import { Menu } from "@headlessui/react"` is importing the `Menu` component from the
`@headlessui/react` library. This library provides accessible and reusable UI components for React
applications. The `Menu` component is used in this code to create a dropdown menu for the wallet
connection button. */
import { Menu } from "@headlessui/react"
import { FunctionComponent } from "react";
import  Link  from "next/link"
import { type } from "os";

/**
 * The type `WalletBarProps` defines the props for a React component that displays wallet information
 * and allows for wallet connection.
 * @property {boolean} isLoading - A boolean value indicating whether the wallet is currently loading
 * or not.
 * @property {boolean} isInstalled - A boolean value indicating whether the wallet is installed or not.
 * @property {string | undefined} account - The `account` property is a string or undefined value that
 * represents the current user's account in the wallet. It could be a public address or some other
 * identifier associated with the user's wallet.
 * @property connect - `connect` is a function that is used to initiate the connection process between
 * the wallet and the application. It is typically called when the user clicks on a "Connect Wallet"
 * button or similar UI element.
 */
type WalletBarProps = {
    isLoading: boolean,
    isInstalled: boolean,
    account: string | undefined,
    connect: () => void,
}

/**
 * This is a functional component that renders a button to connect a wallet.
 * @param  - 1. `isLoading`: A boolean value indicating whether the wallet connection process is
 * currently in progress or not.
 * @returns A JSX element containing a `Menu` component with a `Menu.Button` child element. The
 * `Menu.Button` has the text "Connect Wallet" and some CSS classes for styling. The component takes in
 * some props such as `isLoading`, `isInstalled`, `account`, and `connect`, but they are not currently
 * being used in the returned JSX.
 */
const WalletBar: FunctionComponent <WalletBarProps> = ({
    isLoading,
    isInstalled,
    account,
    connect,
}) => {
    //loading
/* This code block is checking if the `isLoading` prop passed to the `WalletBar` component is true. If
it is true, it returns a JSX element containing a button with the text "Loading..." and some CSS
classes for styling. This is used to indicate to the user that the wallet connection process is
currently in progress. */
    if (isLoading) {
        return (
          <div>
            <button
              onClick={() => {}}
              type="button"
              className="inline-flex items-center px-3 py-1.5 border border-transparent text-base hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              Loading...
            </button>
          </div>
        );
    };

    //account
   /* The `if (account)` statement is checking if the `account` prop passed to the `WalletBar`
   component is truthy (i.e. not null, undefined, 0, false, or an empty string). If it is truthy,
   then the component returns a `Menu` component with a dropdown menu that displays the user's
   account information and a link to their profile. The account information is displayed as a
   shortened version of the account string, with the first two characters and the last four
   characters displayed, and the rest of the characters replaced with ellipses. */
    if (account) {
        return (
          <Menu as="div" className="ml-3 relative">
            <div>
              <Menu.Button className="inline-flex items-center px-3 py-1.5 border border-transparent text-base hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Open user menu
              </Menu.Button>
            </div>

            <Menu.Items>
                <Menu.Item>
                    <button>
                        {`0x${account[2]}${account[3]}${account[4]}...${account.slice(-4)}`}
                    </button>
                </Menu.Item>
                <Menu.Item>
                    <a>
                        Profile
                    </a>
                </Menu.Item>
            </Menu.Items>
          </Menu>
        );
    }

    /* This code block is checking if the `isInstalled` prop passed to the `WalletBar` component is
    true. If it is true, it returns a JSX element containing a button with the text "Connect Wallet"
    and some CSS classes for styling. This button is used to initiate the wallet connection process.
    If `isInstalled` is false, it returns a JSX element containing a button with the text "Install
    Wallet" and an `onClick` event listener that opens the Metamask website in a new tab when
    clicked. This is used to prompt the user to install the Metamask wallet if it is not already
    installed. */
    if (isInstalled) {
        return(
            <div>
                <button>
                    Connect Wallet
                </button>
            </div>
        )
    } else {
        return (
            <div>
                <button onClick={() => {window.open ('https://metamask.io', '_ blank')}} >
                    Install Wallet
                </button>
            </div>
        )
    }

}

export default WalletBar;