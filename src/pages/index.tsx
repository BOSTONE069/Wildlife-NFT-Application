/* `import type { NextPage } from 'next'` is importing the `NextPage` type from the `next` package.
This type is used to define the type of a Next.js page component, which is a React component that is
used to render a page in a Next.js application. By importing the `NextPage` type, we can use it to
define the type of the `Home` component in this file. */
import type { NextPage } from 'next'
/* `import { BaseLayout } from '@/components/ui'` is importing the `BaseLayout` component from the `ui`
folder in the `components` folder of the project. The `@` symbol is a shortcut for the project's
root directory. */
import { BaseLayout } from '@/components/ui'


/**
 * This is a TypeScript React function that renders a home page with a header.
 * @returns A Next.js page component called `Home` is being returned. It renders a `BaseLayout`
 * component that wraps a `div` containing an `h1` element with the text "Home".
 */
const Home: NextPage = () => {
  return (
    <BaseLayout>
      <div>
        <h1>Home</h1>
      </div>
    </BaseLayout>
  )
}

export default Home