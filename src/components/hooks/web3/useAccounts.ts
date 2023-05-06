import { CrytoHookFactory } from "../../../../types/hooks";
import { useEffect, useState } from "react";
import useSWR, { SWRConfiguration, SWRResponse } from "swr";
import { Provider, Web3Provider } from "ethers";
import { MetaMaskInpageProvider } from "@metamask/providers";

type UseAccountResponse = {
  connect: () => void;
  isLoading: boolean;
  isInstalled: boolean;
  account: string | undefined;
};

type AccountHookFactory = CrytoHookFactory<string, UseAccountResponse>;

export type UseAccountHook = ReturnType<AccountHookFactory>;
const connectToMetaMask = async () => {
  try {
    // Detect MetaMask
    const isMetaMask = window.ethereum && window.ethereum.isMetaMask;
    if (!isMetaMask) {
      throw new Error("MetaMask not installed");
    }
    // Request account access if needed
    await window.ethereum.request({ method: "eth_requestAccounts" });
  } catch (err) {
    console.error(err);
  }
};
const useAccount: CryptoHandlerHook <string, UseAccountResponse> = (
  params: any
) => {
  const [account, setAccount] = useState<string | undefined>(undefined);
  const [isInstalled, setIsInstalled] = useState<boolean>(false);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const handleConnect = async () => {
    setIsLoading(true);
    await connectToMetaMask();
    setIsLoading(false);
  };
  useEffect(() => {
    const checkEthereumConnection = async () => {
      const isMetaMask = window.ethereum && window.ethereum.isMetaMask;
      setIsInstalled(isMetaMask);
      if (isMetaMask) {
        const provider = new Web3Provider(
          window.ethereum as MetaMaskInpageProvider
        );
        const signer = provider.getSigner();
        const userAddress = await signer.getAddress();
        setAccount(userAddress);
      }
    };
    checkEthereumConnection();
  }, []);
  const { data } = useSWR(
    [account],
    async () => {
      const balance = await providers.defaultProvider.getBalance(account || "");
      return balance.toString();
    },
    params as SWRConfiguration
  );
  return {
    connect: handleConnect,
    isLoading,
    isInstalled,
    account,
    balance: data,
  };
};
export const hookFectory: AccountHookFactory = () => useAccount;
