/* Importing the `Disclosure` component from the `@headlessui/react` library. The `Disclosure`
component is a UI component that can be used to create collapsible sections of content. */
import { Disclosure } from "@headlessui/react";
import { MenuIcon , XIcon } from "@heroicons/react/outline";

import WalletBar from "./walletbar";

//navigation for market place and create nft

const navigation = [
    {name: "Market Place", href:'/', current: true },
    {name: "Create NFT", href:'/nft/create', current: false},
]

export default function Navbar () {
    return (
        <Disclosure as="nav" className="bg-gray-800">
           <>
           <WalletBar />
           </>
        </Disclosure>
    );
};