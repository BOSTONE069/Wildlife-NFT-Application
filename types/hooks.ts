import { MetaMaskInpageProvider } from "@metamask/providers";
import { providers, Web3Provider } from "ethers";

export type Web3Dependecies = {
  provider: Web3Provider;
  ethereum: MetaMaskInpageProvider;
  isLoading: boolean;
};

export type CrytoHookFactory<D = any, R = any, P = any> = {
  (d: Partial<Web3Dependecies>): CryptoHanlderHook;
};

export type CryptoHanlderHook<D = any, R = any, P = any> = (
  params?: P
) => CrptoSWRResponse<D, R>;

export type CrytoSWRREsponse<D = any, R = any> = SWRResponse<D, R>;
