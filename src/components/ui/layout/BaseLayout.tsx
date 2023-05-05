/* `import { FunctionComponent } from "react";` is importing the `FunctionComponent` type from the
`react` library. This type is used to define functional components in React with TypeScript. It
provides type checking for the props that are passed to the component and the return value of the
component. */
import { FunctionComponent } from "react";

import Navbar from "../navbar";


/**
 * This is a functional component in TypeScript React that renders a base layout with a gray background
 * and a maximum width of 7xl.
 * @param  - The above code defines a functional component named `BaseLayout` which takes in a single
 * prop named `children`. The component returns a JSX element that contains a `div` with a gray
 * background color, some padding, and a minimum height of the screen. Inside this `div`, there is
 * another `
 * @returns The `BaseLayout` component is being returned, which is a functional component that takes in
 * a `children` prop and returns a JSX element. The JSX element contains a `div` with a class name of
 * `py-16 bg-gray-700 overflow-hidden min-h-screen`, which has another `div` inside with a class name
 * of `max-w-7xl mx-auto px-4 space
 */
const BaseLayout: FunctionComponent  = ({ children }) => {
    return (
      <>
      <Navbar />
        <div className="py-16 bg-gray-700 overflow-hidden min-h-screen">
          <div className="max-w-7xl mx-auto px-4 space-y-8 sm:px-6">
            {children}
          </div>
        </div>
      </>
    );
};

export default BaseLayout;